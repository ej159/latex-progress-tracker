#!/bin/sh
./updateProgress.sh && python plotProgress.py latex-progress-tracker-data/progress.csv && okular latex-progress-tracker-data/progress.pdf

