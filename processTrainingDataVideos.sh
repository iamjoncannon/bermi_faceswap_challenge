ffmpeg -i ./weddingplanner.mp4 -vf fps=5 ./JLoSource/maid-video-frame-%d.png
ffmpeg -i ./maidinmanhattan.mp4 -vf fps=5 ./JLoSource/jenny-video-frame-%d.png
ffmpeg -i ./bermi_video.mp4 -vf fps=100 ./original/video-frame-%d.png
cd JLoSource 
mkdir rejects output
autocrop -o output -r rejects -i . --facePercent 75
rm -rf rejects