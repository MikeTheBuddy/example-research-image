#!/bin/bash
set -e

echo "Starting Xvfb..."
Xvfb :1 -screen 0 $RESOLUTION &
sleep 1

echo "Starting Fluxbox..."
fluxbox &
sleep 1

echo "Starting x11vnc..."
x11vnc -display :1 -forever -nopw -quiet -rfbport 5901 &
sleep 1

echo "Starting websockify..."
websockify --web /usr/share/novnc $NOVNC_PORT localhost:$VNC_PORT &
sleep 1

echo "Starting application..."
python /app/app/main.py