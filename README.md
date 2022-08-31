# tesstrain-hindi-impact

Demo of Training workflow for Tesseract 4 for Finetune for Impact training for Hindi Machine Printed Documents
using the tesstrain makefile for training with images and their ground truth transcription.

### leptonica, tesseract

You will need a recent version (>= 4.0.0beta1) of tesseract built with the
training tools and matching leptonica bindings.
[Build](https://github.com/tesseract-ocr/tesseract/wiki/Compiling)
[instructions](https://github.com/tesseract-ocr/tesseract/wiki/Compiling-%E2%80%93-GitInstallation)
and more can be found in the [Tesseract project
wiki](https://github.com/tesseract-ocr/tesseract/wiki/).

### tesstrain

This repo uses a modified version of Makefile from [tesstrain](https://github.com/tesseract-ocr/tesstrain) 
alongwith some bash scripts to run Finetune training.

For tesstrain, single line images and their corresponding ground truth transcription is used.
This repo uses 2 sets of page images with their transcription.

### Finetune training for impact 

Finetune for impact process described as part of tesstutorial is meant for finetuning the traineddata for a single font.
This repo uses images with same typeface (instead of training text and font) for the training.

* First step - 1-makewordstrbox.sh - makes box and lstmf files from page images and their transcription.
* Second step - 2-trainimpact.sh - sets up the files required for training, runs lstmtraining and lstmeval.

### Results of training (limited training data - probably overfitted)

#### jaspreet1

* hin - At iteration 0, stage 0, Eval Char error rate=1.7447785, Word error rate=3.5978507
* script/Devanagari - At iteration 0, stage 0, Eval Char error rate=1.3114632, Word error rate=4.003367
* hinjaspreet1Impact - At iteration 0, stage 0, Eval Char error rate=0, Word error rate=0

#### jaspreet2 

* hin - At iteration 0, stage 0, Eval Char error rate=3.5434626, Word error rate=9.6305108
* script/Devanagari - At iteration 0, stage 0, Eval Char error rate=2.6841831, Word error rate=7.2226686
* hinjaspreet2Impact - At iteration 0, stage 0, Eval Char error rate=0.23175537, Word error rate=0.81453783


* run the command ` bash runall.sh jaspreet1`
* run the command ` bash runall.sh jaspreet2`


## To do Finetune training with your images

* make a new folder eg. `mytraining`
* put (.png) images and their matching groundtruth transcription (.gt.txt) in the folder (preferably 100-200 lines)
* run the command ` bash runall.sh mytraining` (will run training for 400 iterations).

## License

Software is provided under the terms of the `Apache 2.0` license.

Sample training data provided by [Deutsches Textarchiv](https://deutschestextarchiv.de) is [in the public domain](http://creativecommons.org/publicdomain/mark/1.0/).
