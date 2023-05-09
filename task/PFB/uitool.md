#install py3 and pip
```
sudo apt update
sudo apt -y upgrade
sudo apt install -y build-essential libssl-dev libffi-dev python3-dev
python3 -V
sudo apt install -y python3-pip
pip install flask
#có thể chỉ định version cụ thể cho flask bằng lệnh sau
python3 -m pip install Flask==1.1.2
```
# dowload
```
wget uitool.py https://raw.githubusercontent.com/thonguyen14/Celestia/main/task/PFB/uitool.py
wget pfb.sh https://raw.githubusercontent.com/thonguyen14/Celestia/main/task/PFB/pfb.sh
mkdir $HOME/payforblob_wed && cd $HOME/payforblob_wed
wget https://raw.githubusercontent.com/thonguyen14/Celestia/main/task/PFB/index.html
mkdir $HOME/payforblob_wed/templates
cp $HOME/payforblob_wed/index.html $HOME/payforblob_wed/templates/
wget uitool.html https://raw.githubusercontent.com/thonguyen14/Celestia/main/task/PFB/uitool.html

```
# run wed
```
cd
screen -S payforblob_wed
python3 web_server.py
```
