# pull preview to local machine

export PATH="/Users/jonathancannon/myScripts/bin:/Library/Frameworks/Python.framework/Versions/3.7/bin:/Users/jonathancannon/.node_modules_global/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Applications/VMware Fusion.app/Contents/Public/:/Applications/Postgres.app/Contents/Versions/latest/bin"

cd /Users/jonathancannon/python/secondAttempt
aws s3api get-object \
	--bucket jcsecondattempt \
	--key training_preview.jpg \
	preview.jpg

# open preview.jpg