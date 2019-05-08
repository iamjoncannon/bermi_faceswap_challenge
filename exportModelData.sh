# this exports the models and training data to S3
# after the training is in progress (so I don't have to leave
# the EC2 running)

aws s3 sync ./models s3://bermisecondattempt/models
aws s3 sync ./data s3://bermisecondattempt/data 
