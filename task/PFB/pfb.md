#install py3 and pip
```
sudo apt update
sudo apt -y upgrade
sudo apt install -y build-essential libssl-dev libffi-dev python3-dev
python3 -V
sudo apt install -y python3-pip
pip install flask

#uninstall và cài lại flask
pip uninstall flask
pip install flask

#có thể chỉ định version cụ thể cho flask ,ex:
python3 -m pip install Flask==1.1.2
```
# dowload
```
mkdir $HOME/wed_pfb && cd $HOME/wed_pfb
wget wed_server.py https://raw.githubusercontent.com/thonguyen14/Celestia/main/task/PFB/wed_server.py
wget pfb.sh https://raw.githubusercontent.com/thonguyen14/Celestia/main/task/PFB/pfb.sh
wget index.html https://raw.githubusercontent.com/thonguyen14/Celestia/main/task/PFB/index.html
mkdir $HOME/wed_pfb/templates
cp $HOME/wed_pfb/index.html $HOME/wed_pfb/templates/

```
# run wed
```
cd
screen -S wed_pfb
python3 wed_server.py
```
