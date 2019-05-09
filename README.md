# FaceSwap Challenge

This repo documents my use of the FaceSwap library https://github.com/deepfakes/faceswap to transform the woman in bermi_video.mp4 into the Latina celebrity Jennifer Lopez. The training was done on a AWS EC2 p series instance optimized for Deep Learning, running NVIDA CUDA GPUs. A container image was captured from the final machine instance used to complete the training, and can be accessed on the AWS AMI registry at ami-00f5a1dbd1440c90b.

The FaceSwap library utilized had extensive settings that were not discussed in the README, but rather displayed in the "help" option for each CLI call (see help.txt). This information was critical to improving the output of the initial training attempt.

## Source training data

Training data can be accessed at 
https://s3.amazonaws.com/bermithirdattempt/

or via aws s3 cli at: s3://bermithirdattempt

```Bash
aws s3 sync s3://bermithirdattempt targetDirectory/
```

The training data (in JLoSource) was extracted from two Jennifer Lopez films, "Maid in Manhattan" and "The Wedding Planner" using two libraries, ffmpeg and autocrop (see processTrainingDataVideos.sh). This provided the ML library a robust data set of thousands of images to generate the facial model.

While the faceswap library itself does some processing/cropping of the source images, the data was cropped and then filtered for false positives and low resolution images. A higher fps (100 rather than 30) was chosen to process the source video in order to improve final resolution.

## Hardware Choice

AWS provides three base hardware configurations for Deep Learning the GPU required by the underlying FaceSwap library (NVIDIA CUDA), p2xlarge with 1 GPU ($.9/hour), p2x8large with 8 GPU ($7.2/hour), and p2x16large with 16 GPU machines ($14/hour). 

In order to reduce cost, initial tests were done on the 1 GPU machine running Ubuntu Linux. A machine image was generated with the faceswap library installed and running properly, and subsequent training session utilized the image on p2x8large EC2. The "training" and "convert" methods in the python library allow options to expand GPUs used for processing. While a Dockerfile was provided, utilizing AWS's AMI was found to be a more efficient workflow. 

## Extract training data

Training data was processed locally then relayed to remote machine via S3. 

See "extract.sh" for the scripts used to extract training data from the JLo photos and source video.

Several settings were critical to improving subsequent training iterations.

```bash
python faceswap.py extract \
	-i ./training_data/original_video \
	-o ./training_data/ffmpeg_vid \
	-mp \
	-r 30 \
	-A fan \
	-D s3fd \
	-min 50 

```

In initial test, the face in the second half of the video was not targeted by the library for swapping. The r flag instructs the library to rotate each source image 30 degrees until a face is identified, and successfully targeted the woman's profile in the second half of the video.

The library utilizes an alignment algorithm to target faces more precisely (-A), as well as a facial detector (-D). A floor for face size was chosen to filter smaller images (-min). Each option was explored by generating an image set and examining the outcome over several iterations.

## Train the model

The faceswap library runs tensor flow machine learning algorithms to analyze the photos in each source file (in the 'data' folder). In initial tests, the faceswap library could not target the woman's face in the second half of the original video for swapping.

Subsequent attempts experimented with alignment ("-ala -alb") options as well as using a rotation option to better target faces in the source photos (-A and -r above).  See "train.sh." These were utilized in the train call with "-ala" and "-alb" options, which point the training algorithm to an alignment.json file that contains precise information on each source file. 

The full call utilized was:

```Bash
python faceswap.py train \
	-A ./training_data/ffmpeg_vid  \
	-ala ./training_data/align/source/alignments.json \
	-B ./training_data/JLo \
	-alb ./training_data/align/JLo/alignments.json \
	-m ./model \
	-g 8 \
	-t original \
	-bs 256 \
	-w \

```

The -bs option optimized training by defining the batch size, ie the number of images used in each iteration. This had to be the closet power of two below the total number of source images.

The -w option outputs an image periodically to observe progress (see preview.jpg). The images was automatically relayed to local machine via s3 through cronjobs on each machine (calling getPreview.sh and putPreview.sh every two minutes) for continuous monitoring throughout the training process. This monitoring resulted in several additional extraction iterations to improve overall results.

## Convert source video woman to JLo

After training, the model is utilizd to process the original video and generate a swapped version (see convertScript.sh).
The FaceSwap library exposed a cli method to automatically generate a new from the photos.  Setting selection here was critical to the final outcome.

Because this process required several steps, a script was utilized to pseudo-terminal into the remote session, pause training, generate the video, relay the video between remote and local machines via s3, and restart the training process. This allowed specific options to be changed and experimented with easily, critical for finding the correct settings for the final video: 

```Bash
python faceswap.py convert \
	-i ./training_data/original_video \
	-o ./training_data/output \
	-m ./model \
	-c match-hist  \
	-sc sharpen \
	-g 1 \
	-t original \
	-w ffmpeg \
	-ref bermi_video.mp4  # automatically generates a video from the source images
```

See notes in convertScript.sh for specific setting discussion. The major improvement was the '-c match-hist and -sc sharpen' option.

## Conclusion

The AMI provided has a base model that can be improved upon with further training data. 

Based on forum discussion, a typical training job with a more advanced model (aka the villain model within the underlying library) might require up to 48 hours of training on a powerful machine (8-16 GPU card).

While EC2 provides a convenient platform to run training, a more robust and precise outcome would require dedicated local hardware, as subsequent training jobs would quickly become cost prohibitive ($7/hour for an 8 GPU machine x 48 hours would be over $300).  
