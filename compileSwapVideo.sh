# this pulls the swapped photos from the S3
# then compiles a video from the still images
# inside swapped_video folder

cd swapped_video
aws s3 sync s3://jcsecondattempt/swapped_video .  --delete
ffmpeg -i video-frame-%0d.png -c:v libx264 -vf "fps=30,format=yuv420p" out.mp4
open out.mp4

