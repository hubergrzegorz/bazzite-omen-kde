#!/bin/bash

MARKER="$HOME/.config/first_run_audio_done"

if [ -f "$MARKER" ]; then
    exit 0
fi

# odtwórz 30 sekund MP3
ffplay -nodisp -autoexit -t 60 /usr/share/sounds/first-run.mp3 >/dev/null 2>&1

# utwórz marker
touch "$MARKER"
