#!/bin/bash

MARKER="$HOME/.config/first_run_audio_done"

if [ -f "$MARKER" ]; then
    exit 0
fi

# odtwórz 30 sekund MP3
mpv --no-video --length=60 /usr/share/sounds/first-run.mp3

# utwórz marker
touch "$MARKER"
