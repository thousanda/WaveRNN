#!/bin/bash

source /path/to/venv/bin/activate

DIR=/path/to/WaveRNN
LOG_FILE=$DIR/scripts/log/train.log

cd $DIR || exit

mkdir -p scripts/log
if [ -f "$LOG_FILE" ]; then
    mv $LOG_FILE ${LOG_FILE}.backup
fi

{
    date
    # python wavernn.py -m <model> --scratch (for flat start) -g (for generation)
    python -u wavernn.py \
        --scratch
    date
} > $LOG_FILE 2>&1
