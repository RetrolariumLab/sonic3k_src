"""Windows process snapshots and handle-bound cleanup of known descendants."""

import ctypes
from ctypes import wintypes
import os


class ProcessEntry(ctypes.Structure):
    _fields_ = [
        ("size", wintypes.DWORD),
        ("usage", wintypes.DWORD),
        ("pid", wintypes.DWORD),
        ("heap", ctypes.c_size_t),
        ("module", wintypes.DWORD),
        ("threads", wintypes.DWORD),
        ("parent", wintypes.DWORD),
        ("priority", wintypes.LONG),
        ("flags", wintypes.DWORD),
        ("name", wintypes.WCHAR * 260),
    ]


def kernel():
    api = ctypes.WinDLL("kernel32", use_last_error=True)
    declarations = {
        "CreateToolhelp32Snapshot": ([wintypes.DWORD, wintypes.DWORD], wintypes.HANDLE),
        "Process32FirstW": ([wintypes.HANDLE, ctypes.POINTER(ProcessEntry)], wintypes.BOOL),
        "Process32NextW": ([wintypes.HANDLE, ctypes.POINTER(ProcessEntry)], wintypes.BOOL),
        "OpenProcess": ([wintypes.DWORD, wintypes.BOOL, wintypes.DWORD], wintypes.HANDLE),
        "GetProcessTimes": ([wintypes.HANDLE] + [ctypes.POINTER(wintypes.FILETIME)] * 4, wintypes.BOOL),
        "GetExitCodeProcess": ([wintypes.HANDLE, ctypes.POINTER(wintypes.DWORD)], wintypes.BOOL),
        "TerminateProcess": ([wintypes.HANDLE, wintypes.UINT], wintypes.BOOL),
        "WaitForSingleObject": ([wintypes.HANDLE, wintypes.DWORD], wintypes.DWORD),
        "CloseHandle": ([wintypes.HANDLE], wintypes.BOOL),
    }
    for name, (arguments, result) in declarations.items():
        function = getattr(api, name)
        function.argtypes, function.restype = arguments, result
    return api


def creation_time(api, handle):
    values = [wintypes.FILETIME() for _ in range(4)]
    if not api.GetProcessTimes(handle, *(ctypes.byref(value) for value in values)):
        raise ctypes.WinError(ctypes.get_last_error())
    return values[0].dwHighDateTime << 32 | values[0].dwLowDateTime


def snapshot():
    api = kernel()
    handle = api.CreateToolhelp32Snapshot(2, 0)
    if handle in (None, ctypes.c_void_p(-1).value):
        raise ctypes.WinError(ctypes.get_last_error())
    rows = {}
    try:
        entry = ProcessEntry()
        entry.size = ctypes.sizeof(entry)
        valid = api.Process32FirstW(handle, ctypes.byref(entry))
        while valid:
            rows[int(entry.pid)] = {"pid": int(entry.pid), "parent": int(entry.parent), "name": entry.name}
            valid = api.Process32NextW(handle, ctypes.byref(entry))
        if ctypes.get_last_error() != 18:
            raise ctypes.WinError(ctypes.get_last_error())
    finally:
        api.CloseHandle(handle)
    return rows


def ancestry(pid, rows):
    chain = []
    parent = rows[pid]["parent"]
    while parent and parent not in chain:
        chain.append(parent)
        if parent not in rows:
            break
        parent = rows[parent]["parent"]
    return chain


def processes():
    if os.name != "nt":
        return []
    api, rows, result = kernel(), snapshot(), []
    for pid, row in rows.items():
        if row["name"].lower() != "consoles.exe":
            continue
        created = None
        handle = api.OpenProcess(0x1000, False, pid)
        if handle:
            try:
                code = wintypes.DWORD()
                if api.GetExitCodeProcess(handle, ctypes.byref(code)) and code.value != 259:
                    continue
                created = creation_time(api, handle)
            finally:
                api.CloseHandle(handle)
        result.append({"pid": pid, "created": created, "ancestors": ancestry(pid, rows)})
    return result


def remember_owned(rows, parent, owned):
    for row in rows:
        if parent in row["ancestors"]:
            if not isinstance(row["created"], int) or row["created"] <= 0:
                raise ValueError("Cannot establish the creation identity of an owned MAME process")
            owned[row["pid"]] = row["created"]


def owned_leftovers(rows, owned):
    return [row for row in rows if row["pid"] in owned and owned[row["pid"]] == row["created"]]


def terminate_owned(pid, expected, api=None):
    api = api or kernel()
    handle = api.OpenProcess(0x101001, False, pid)
    if not handle:
        return False
    try:
        # Check and terminate through this same handle: a reused PID cannot
        # redirect cleanup between a timestamp check and a PID-based kill.
        if creation_time(api, handle) != expected:
            return False
        if not api.TerminateProcess(handle, 1):
            raise ctypes.WinError(ctypes.get_last_error())
        if api.WaitForSingleObject(handle, 5000) != 0:
            raise RuntimeError("Owned MAME process did not terminate")
        return True
    finally:
        api.CloseHandle(handle)
