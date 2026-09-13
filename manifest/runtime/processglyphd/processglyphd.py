#!/usr/bin/env python3
import errno
import fcntl
import os
import re
import struct
import subprocess
import sys
import time

EVIOCGRAB = 0x40044590
EV_KEY = 1

TARGET_NAME = "8BitDo Retro 18 Numpad Keyboard"
RETRY_SECONDS = 2.0

GLYPH_MAP = {
    79: "▽",
    80: "☰",
    81: "☷",
    75: "☵",
    76: "☳",
    77: "☴",
    71: "☲",
    72: "☶",
    73: "☱",
    82: "△",
    98: "⋯",
    55: "⊞",
    74: "◈",
    78: "▲",
}

ACTION_MAP = {
    83: ("space", ["xdotool", "key", "--clearmodifiers", "space"]),
    96: ("enter", ["xdotool", "key", "--clearmodifiers", "Return"]),
    14: ("backspace", ["xdotool", "key", "--clearmodifiers", "BackSpace"]),
}

KEY_NAMES = {
    14: "KEY_BACKSPACE",
    55: "KEY_KPASTERISK",
    71: "KEY_KP7",
    72: "KEY_KP8",
    73: "KEY_KP9",
    74: "KEY_KPMINUS",
    75: "KEY_KP4",
    76: "KEY_KP5",
    77: "KEY_KP6",
    78: "KEY_KPPLUS",
    79: "KEY_KP1",
    80: "KEY_KP2",
    81: "KEY_KP3",
    82: "KEY_KP0",
    83: "KEY_KPDOT",
    96: "KEY_KPENTER",
    98: "KEY_KPSLASH",
}


def log(message):
    print(time.strftime("%Y-%m-%d %H:%M:%S"), message, flush=True)


def find_event_device():
    try:
        with open("/proc/bus/input/devices", "r", encoding="utf-8", errors="replace") as f:
            blocks = f.read().split("\n\n")
    except FileNotFoundError:
        return None

    for block in blocks:
        if f'N: Name="{TARGET_NAME}"' not in block:
            continue

        match = re.search(r"H: Handlers=.*\b(event\d+)\b", block)
        if not match:
            return None

        return f"/dev/input/{match.group(1)}"

    return None


def event_struct_format():
    fmt = "llHHI"
    size = struct.calcsize(fmt)
    if size != 24:
        raise RuntimeError(f"unexpected input_event size: {size}")
    return fmt, size


def x_env():
    env = os.environ.copy()
    env.setdefault("DISPLAY", ":0")
    env.setdefault("XAUTHORITY", os.path.expanduser("~/.Xauthority"))
    return env


def run_xdotool(command):
    subprocess.run(
        command,
        env=x_env(),
        check=False,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )


def type_glyph(glyph):
    run_xdotool(["xdotool", "type", "--clearmodifiers", glyph])


def send_action(command):
    run_xdotool(command)


def handle_key(code):
    name = KEY_NAMES.get(code, f"KEY_{code}")

    glyph = GLYPH_MAP.get(code)
    if glyph is not None:
        log(f"{name} -> {glyph}")
        type_glyph(glyph)
        return

    action = ACTION_MAP.get(code)
    if action is not None:
        label, command = action
        log(f"{name} -> {label}")
        send_action(command)


def read_grabbed_device(path, fmt, size):
    fd = os.open(path, os.O_RDONLY)
    grabbed = False

    try:
        fcntl.ioctl(fd, EVIOCGRAB, 1)
        grabbed = True
        log(f"grab ok: {path}")

        while True:
            try:
                data = os.read(fd, size)
            except OSError as err:
                if err.errno in (errno.ENODEV, errno.EIO):
                    log(f"device disappeared: {path}")
                    return
                raise

            if len(data) != size:
                continue

            _sec, _usec, ev_type, code, value = struct.unpack(fmt, data)
            if ev_type == EV_KEY and value == 1:
                handle_key(code)

    finally:
        if grabbed:
            try:
                fcntl.ioctl(fd, EVIOCGRAB, 0)
                log(f"grab released: {path}")
            except OSError:
                pass
        os.close(fd)


def main():
    fmt, size = event_struct_format()
    log(f"processglyphd start: target={TARGET_NAME}")

    while True:
        path = find_event_device()
        if not path:
            log("device not found; waiting")
            time.sleep(RETRY_SECONDS)
            continue

        try:
            read_grabbed_device(path, fmt, size)
        except PermissionError:
            log(f"permission denied: {path}; user needs access to input devices")
            time.sleep(RETRY_SECONDS)
        except FileNotFoundError:
            log(f"event node vanished: {path}")
            time.sleep(RETRY_SECONDS)
        except KeyboardInterrupt:
            log("processglyphd stop")
            return 0
        except Exception as err:
            log(f"error: {type(err).__name__}: {err}")
            time.sleep(RETRY_SECONDS)


if __name__ == "__main__":
    sys.exit(main())
