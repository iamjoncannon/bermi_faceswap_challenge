# this intializes the training data into its folder for the training
python faceswap.py extract \
	-i ./raw \
	-o ./training_data/JLo \
	-mp \
	-D s3fd \
	-r 1 \
	-A fan 

python tools.py effmpeg \
	-a extract \
	-i bermi_video.mp4 \
	-fps -1 \
	-ef .png \

python faceswap.py extract \
	-i ./training_data/original_video \
	-o ./training_data/ffmpeg_vid \
	-mp \
	-r 30 \
	-A fan \
	-D s3fd \
	-min 50 
	# -bt 30 \
	# -bt .5 \
