# "git push origin master" for s3

aws s3 sync JLoSource/ s3://jcsecondattempt/JLoSource 
aws s3 sync original/ s3://jcsecondattempt/original
aws s3 sync swapped_video/ s3://jcsecondattempt/swapped_video  