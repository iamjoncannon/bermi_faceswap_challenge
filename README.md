# FaceSwap Challenge

This repo documents my use of the Face Swap library to turn the woman in bermi_video.mp4 into the Latina celebrity Jennifer Lopez. 

## Sourcing training data

The training data (in JLoSource) was extracted from two Jennifer Lopez films, "Maid in Manhattan" and "The Wedding Planner" using two libraries, ffmpeg and autocrop. This provided the ML library with thousands of images, giving a robust data set to generate the facial model.

See "processTrainingDataVideos.sh" script.

While the faceswap library itself does some processing/cropping of the source images, the data was cropped and then filtered for false positives and low resolution images. The original video was processed at a higher frame rate to increase resolution of the resulting image.

## Hardware Choice

Initial tests were done utilizing p2xlarge EC2 running Ubuntu. An AMI was generated with faceswap library installed and running properly, and the final training session utilized the image on an p2x8large EC2. 

NOTE: The faceswap library included a Docker file, however the p2 series EC2 already contains and was optimized for the Deep Learning libraries (TensorFlow, etc) installed. Containerization seemed redundant and inefficient. 

## Extract- generate training data

Training data was processed locally then relayed to remote machine via S3. 

See "install.sh" and "initModels.sh" scripts for installation of EC2 used for final training. 

## train- train the model

The faceswap library runs tensor flow machine learning algorithms to analyze the photos in each source file (in the 'data' folder).  

The initial tests utilized the default model, but results were suboptimal, as the faceswap library could not target the woman's face in the second half of the original video for swapping (see 'firstattempt.mp4').

After some research, the "-ala -alb" option was found and implemented in the second attempt. When the library intiailizes the data (in the previous step), it also generates an alignment file (this is unfortunately not documented in the library's README but was found in the forum). The second attempt pointed the library to the alignment files to improve results.

The full training method call was as follows:

```bash
python faceswap.py train -A ./data/src -ala ./original -B ./data/JLo -alb ./JLoSource/output -m ./model -t villain -w
```

Note: the -w option outputs an image periodically to observe progress. 

## convert - generate swap video from model

After creating a model, the library uses the model to process the original video and generate a swapped version.

This call is as follows:

```bash
python faceswap.py convert -i ./original -o ./data/output -m ./models -ref bermi_video.mp4
```

Note: the library can utilize the source video as a reference via "-ref".
