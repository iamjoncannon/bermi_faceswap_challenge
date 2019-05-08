# this imports the models and training data from a previous EC2
# after the training is in progress (so I don't have to leave
# the EC2 running)

aws s3 sync s3://bermisecondattempt/models ./models 
aws s3 sync s3://bermisecondattempt/data ./data