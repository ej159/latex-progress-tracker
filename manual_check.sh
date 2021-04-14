#!/bin/sh
./updateProgress.sh && python plotProgress.py latex-progress-tracker-data/progress.csv && eog latex-progress-tracker-data/progress.png

