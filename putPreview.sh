# the training call generates a preview jpg, this 
# relays it to the s3

export PATH='/usr/bin:/bin:/usr/sbin'

aws s3api put-object \
	--bucket jcsecondattempt \
	--key training_previewTwo.jpg \
	--body training_preview.jpg

