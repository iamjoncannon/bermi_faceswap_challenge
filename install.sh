# this shells in from the local machine to remote machine and performs intialization

cd ~/.ssh
ssh -T -i $key ubuntu@$faceSwapMachine << 'ENDSSH'
sudo apt-get update
cd faceswap
mkdir -p training_data/JLo training_data/original model raw
aws s3 sync s3://jcsecondattempt . 
sudo chmod +x initModels.sh
./initModels.sh
ENDSSH