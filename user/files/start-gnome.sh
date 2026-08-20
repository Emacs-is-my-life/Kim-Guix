#!/bin/sh

export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=GNOME
export XDG_SESSION_DESKTOP=gnome
export DESKTOP_SESSION=gnome

# Ensure LibreWolf/Firefox uses native Wayland and its portal path.
export MOZ_ENABLE_WAYLAND=1
export GDK_BACKEND=wayland,x11

exec dbus-run-session -- gnome-session
