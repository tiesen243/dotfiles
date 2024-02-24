#!/bin/bash

pulseaudio -k
systemctl --user enable pulseaudio && systemctl --user start pulseaudio
