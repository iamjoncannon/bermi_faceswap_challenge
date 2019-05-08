# this intializes the training data into its folder for the training
python faceswap.py extract \
	-i ./JLoSource/output \
	-o ./training_data/JLo \
	-mp \
	-D s3fd \
	-r 1 \
	-bt .5 \
	-A fan 

python faceswap.py extract \
	-i ./original \
	-o ./training_data/src \
	-mp \
	-D s3fd \
	-r 1 \
	-bt .5 \
	-A fan 