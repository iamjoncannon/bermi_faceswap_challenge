# "git push origin master" for s3

aws s3 sync . s3://jcsecondattempt --exclude "sync.sh"