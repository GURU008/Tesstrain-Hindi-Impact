#!/bin/bash
# $1 jaspreet1, jaspreet2

export PYTHONIOENCODING=utf8
ulimit -s 65536
SCRIPTPATH=`pwd`
MODEL=hin$1

rm -rf data/$MODEL
mkdir data/$MODEL

cd data/$MODEL
wget -O $MODEL.config https://github.com/tesseract-ocr/langdata_lstm/raw/master/hin/hin.config
wget -O $MODEL.numbers https://github.com/tesseract-ocr/langdata_lstm/raw/master/hin/hin.numbers
wget -O $MODEL.punc https://github.com/tesseract-ocr/langdata_lstm/raw/master/hin/hin.punc

mkdir -p ../script/Devanagari
combine_tessdata -e ~/tessdata_best/script/Devanagari.traineddata $SCRIPTPATH/data/script/Devanagari/$MODEL.lstm

find $SCRIPTPATH/$1 -type f -name '*.lstmf' > all-$MODEL-lstmf  
python3 $SCRIPTPATH/shuffle.py 1 < all-$MODEL-lstmf > all-lstmf

echo "" > all-gt
cat $SCRIPTPATH/$1/*.gt.txt >> all-gt 

cd ../..

make  training  \
MODEL_NAME=$MODEL  \
LANG_TYPE=Indic \
BUILD_TYPE=Impact  \
TESSDATA=/home/ubuntu/tessdata_best \
GROUND_TRUTH_DIR=$SCRIPTPATH/$1 \
START_MODEL=script/Devanagari \
RATIO_TRAIN=0.99 \
DEBUG_INTERVAL=-1 \
MAX_ITERATIONS=400 

lstmtraining \
  --stop_training \
  --continue_from data/hin${1}/checkpoints/hin${1}Impact_checkpoint \
  --traineddata /home/ubuntu/tessdata_best/script/Devanagari.traineddata \
  --model_output data/hin${1}/hin${1}Impact.traineddata

lstmtraining \
  --stop_training \
  --convert_to_int \
  --continue_from data/hin${1}/checkpoints/hin${1}Impact_checkpoint \
  --traineddata /home/ubuntu/tessdata_best/script/Devanagari.traineddata \
  --model_output data/hin${1}/hin${1}Impact_fast.traineddata

	OMP_THREAD_LIMIT=1   time -p  lstmeval  \
	  --model ~/tessdata_best/script/Devanagari.traineddata \
	  --eval_listfile data/hin${1}/all-lstmf \
	  --verbosity 0

	OMP_THREAD_LIMIT=1   time -p  lstmeval  \
	  --model ~/tessdata_best/hin.traineddata \
	  --eval_listfile data/hin${1}/all-lstmf \
	  --verbosity 0

	OMP_THREAD_LIMIT=1   time -p  lstmeval  \
	  --model data/hin${1}/hin${1}Impact.traineddata \
	  --eval_listfile data/hin${1}/all-lstmf \
	  --verbosity 0

	OMP_THREAD_LIMIT=1   time -p  lstmeval  \
	  --model data/hin${1}/hin${1}Impact_fast.traineddata \
	  --eval_listfile data/hin${1}/all-lstmf \
	  --verbosity 0
