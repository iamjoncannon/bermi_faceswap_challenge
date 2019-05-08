# this shells in from the local machine to remote machine and performs intialization

cd ~/.ssh
ssh -T -i $key ubuntu@$faceSwapMachine << 'ENDSSH'
sudo apt-get update
cd faceswap
rm -rf model models data
mkdir -p training_data/JLo training_data/original model raw
git clone https://github.com/iamjoncannon/bermi_faceswap_challenge.git 
cp bermi_faceswap_challenge/* .
rm -rf bermi_faceswap_challenge
sudo chmod +x s3syncremote.sh
./s3syncremote.sh
sudo chmod +x extract.sh
./extract.sh
exit
ENDSSH