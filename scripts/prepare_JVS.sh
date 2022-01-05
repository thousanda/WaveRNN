#!/bin/bash

source /path/to/venv/bin/activate

DIR=/path/to/WaveRNN
JVS_DIR=/path/to/jvs
OUT_DIR=$DIR/data/jvs
LOG_FILE=$DIR/scripts/log/prepare_JVS.log

cd $DIR || exit

mkdir -p scripts/log
if [ -f "$LOG_FILE" ]; then
    mv $LOG_FILE ${LOG_FILE}.backup
fi

{
    date

    # Create symbolic links of waf files
    for num in $(seq -f %03g 100); do
        spkr="jvs$num"
        echo -n "Making symbolic links of $spkr..."
        mkdir -p "$OUT_DIR/links/$spkr"
        para_dir=$JVS_DIR/$spkr/parallel100/wav24kHz16bit
        nonpara_dir=$JVS_DIR/$spkr/nonpara30/wav24kHz16bit
        for wav in $(find "$para_dir" "$nonpara_dir" -name "*.wav"); do
            base=$(basename "$wav")
            ln -s "$wav" "$OUT_DIR/links/$spkr/$base"
        done
        echo "done"
    done

    date

    # Run preprocess
    # python preprocess_multispeaker.py /path/to/dataset/VCTK-Corpus/wav48 /path/to/directory
    python -u preprocess_multispeaker.py \
        $OUT_DIR/links \
        $OUT_DIR/npy

    date
} > $LOG_FILE 2>&1
