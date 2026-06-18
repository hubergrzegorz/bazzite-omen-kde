#!/usr/bin/env bash

alias restart='systemctl reboot'
alias status='rpm-ostree status'
alias changelog='rpm-ostree db diff | sed "1,2d"'
