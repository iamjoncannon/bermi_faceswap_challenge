# train call

python faceswap.py train \
	-A ./training_data/src  \
	-ala ./original/alignments.json \
	-B ./training_data/JLo \
	-alb ./JLoSource/output/alignments.json \
	-m ./model \
	-g 1 \
	-t villain \
	-bs 8 \
	-w \
	-wl 