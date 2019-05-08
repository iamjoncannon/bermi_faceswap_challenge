# this uses the ML model to swap the original woman's face into JLo 

python faceswap.py convert -i \
	./original -o \
	./data/output \
	-m ./model \
	-c color-transfer \
	-sc sharpen \
	-M predicted \
	-g 1 \
	-t villain \
	-w ffmpg \
	-ref bermi_video.mp4 \
	-t villain /

aws s3 sync data/output/ s3://jaylow/Final_Output --delete 