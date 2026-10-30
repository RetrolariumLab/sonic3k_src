"""Prepare a pinned emulator and serialize runs without touching other tasks."""

import csv
import ctypes
from ctypes import wintypes
import io
import os
from pathlib import Path
import platform
import shutil
import subprocess
import time

from scripts.build.project import ROOT, atomic, load, rltool, sha


def validate_executable(data, expected):
    if len(data) != expected["size"] or sha(data) != expected["sha256"]:
        raise ValueError("MAME executable differs from the pinned build")


def prepare(named=None):
    spec = load("config/runtime/emulator.json")
    host = "windows-x86_64" if os.name == "nt" and platform.machine().lower() in ("amd64", "x86_64") else "unsupported"
    if host not in spec["hosts"]:
        raise ValueError("Full runtime is not accepted on this host; ROM-less checks remain available")
    target = ROOT / "build/runtime/mame/consoles.exe"
    expected = spec["hosts"][host]
    if target.is_file():
        validate_executable(target.read_bytes(), expected)
        return target
    source = Path(named or os.environ.get("RETROLARIUM_MAME") or rltool("movie", "mame"))
    if not source.is_file():
        raise ValueError("Name the pinned MAME through --mame or RETROLARIUM_MAME")
    data = source.read_bytes()
    validate_executable(data, expected)
    atomic(target, data)
    return target


def listed_process_ids(raw):
    # tasklist follows the Windows console code page. Process names/PIDs are
    # ASCII; localized status/memory fields must not break the busy guard.
    text = raw.decode("utf-8", errors="replace")
    result = []
    for row in csv.reader(io.StringIO(text)):
        if len(row) >= 2 and row[0].lower() == "consoles.exe":
            result.append(int(row[1]))
    return result


def active_processes():
    if os.name != "nt":
        return []
    result = subprocess.run(
        ["tasklist", "/fi", "IMAGENAME eq consoles.exe", "/fo", "csv", "/nh"],
        capture_output=True,
        creationflags=0x08000000,
        check=True,
    )
    kernel = ctypes.WinDLL("kernel32", use_last_error=True)
    kernel.OpenProcess.argtypes = [wintypes.DWORD, wintypes.BOOL, wintypes.DWORD]
    kernel.OpenProcess.restype = wintypes.HANDLE
    kernel.GetExitCodeProcess.argtypes = [wintypes.HANDLE, ctypes.POINTER(wintypes.DWORD)]
    kernel.GetExitCodeProcess.restype = wintypes.BOOL
    kernel.CloseHandle.argtypes = [wintypes.HANDLE]
    pids = []
    for pid in listed_process_ids(result.stdout):
        handle = kernel.OpenProcess(0x1000, False, pid)
        if not handle:
            pids.append(pid)
            continue
        code = wintypes.DWORD()
        ok = kernel.GetExitCodeProcess(handle, ctypes.byref(code))
        kernel.CloseHandle(handle)
        if not ok or code.value == 259:
            pids.append(pid)
    return pids


def wait_idle(timeout):
    started = time.monotonic()
    reported = -1
    while True:
        pids = active_processes()
        if not pids:
            return
        elapsed = int(time.monotonic() - started)
        if elapsed // 30 != reported:
            print("[WAIT] Existing MAME process(es): " + ", ".join(map(str, pids)), flush=True)
            reported = elapsed // 30
        if elapsed >= timeout:
            raise RuntimeError("MAME stayed busy; no second run was started")
        time.sleep(1)


def run_movie(args, log):
    from scripts.build.project import rltool_command

    spec = load("config/runtime/emulator.json")
    wait_idle(spec["busy_timeout_seconds"])
    temporary = ROOT / "build/runtime/tmp"
    temporary.mkdir(parents=True, exist_ok=True)
    env = dict(os.environ, TEMP=str(temporary), TMP=str(temporary), TMPDIR=str(temporary))
    log.parent.mkdir(parents=True, exist_ok=True)
    with log.open("w", encoding="utf-8") as stream:
        proc = subprocess.Popen(
            [*rltool_command(), "movie", *map(str, args)],
            cwd=ROOT,
            env=env,
            stdout=stream,
            stderr=subprocess.STDOUT,
            creationflags=0x08000000 if os.name == "nt" else 0,
        )
        try:
            code = proc.wait(timeout=spec["run_timeout_seconds"])
        except subprocess.TimeoutExpired:
            # Kill only the runner process tree we created. A shell timeout
            # alone would leave its MAME child alive on Windows.
            if os.name == "nt":
                subprocess.run(["taskkill", "/PID", str(proc.pid), "/T", "/F"], capture_output=True)
            else:
                proc.kill()
            raise RuntimeError("Owned MAME runner exceeded its frame/run budget")
    if code:
        raise RuntimeError(log.read_text(encoding="utf-8", errors="replace")[-3000:])
    wait_idle(spec["busy_timeout_seconds"])
