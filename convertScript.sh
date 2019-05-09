# shell in from the local machine, converts a video 
# and relays the convererted video back over S3
# quickly experiment with conversion settings

# shell into remote machine

cd ~/.ssh
ssh -T -i $key ubuntu@$faceSwapMachine << 'ENDSSH'
tmux kill-session -t train
cd faceswap
python faceswap.py convert \
	-i ./training_data/original_video \
	-o ./training_data/output \
	-m ./model \
	-c match-hist  \
	-sc sharpen \
	-g 1 \
	-t original \
	-w ffmpeg \
	-ref bermi_video.mp4 

aws s3 sync training_data/ s3://bermithirdattempt/training_data/
tmux new-session -d -s train './train.sh'
exit
ENDSSH

# back on the local machine

cd /Users/jonathancannon/python/secondAttempt
aws s3 sync s3://bermithirdattempt/training_data/ training_data/
open training_data/output/bermi_video_converted.mp4

# Notes on settings

# -c - match-hist clearly superior to  avg-color and color-transfer
# -sc sharpen \ somewhat improvement, not marked
# -M \ components, dfl_full, facehull- no real change
#	"predicted" softens results, but not an improvement

## This worked well

# python faceswap.py convert \
# 	-i ./training_data/original_video \
# 	-o ./training_data/output \
# 	-m ./model \
# 	-c match-hist \ 
# 	-sc sharpen \
# 	-g 1 \
# 	-t original \
# 	-w ffmpeg \
# 	-ref bermi_video.mp4 