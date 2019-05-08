# this shells in from the local machine to remote machine and performs intialization

cd ~/.ssh
ssh -T -i $key ubuntu@$faceSwapMachine << 'ENDSSH'
sudo apt-get update
cd faceswap
rm -rf model models 
mkdir -p training_data/JLo training_data/original model raw
aws s3 sync s3://jcsecondattempt .
git clone https://github.com/iamjoncannon/bermi_faceswap_challenge.git 
sudo chmod +x extract.sh
./extract.sh
ENDSSH