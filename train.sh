# train call
# one line to run in tmux:
# tmux new-session -d -s train './train.sh'

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
	# -wl 

