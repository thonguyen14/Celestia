**Instructions for setting up telegram bot to check useful CLI commands for Celestia network**
# Install npm
```
npm install -g npm@9.6.3
mkdir $HOME/cosmos_haqq_bot && cd $HOME/cosmos_haqq_bot
npm install telegraf nodemon axios start --save
```
# Add Telegram bot
- Using [@BotFather](https://t.me/BotFather) to create your BOT, pay attention to HTTP API

![image](https://user-images.githubusercontent.com/80441573/229410996-94503999-d2e4-4ba4-a4ec-fd0cd0aa25a6.png)

- Download `form.js` file and add API of your BOT
```
wget -O form.js https://raw.githubusercontent.com/thonguyen14/Celestia/main/task/toolcheck/form.js
```
# Start BOT
```
cd
which screen
#if not have screen , run the current command to install
apt install screen
screen -S telebot
```
```
cd $HOME/cosmos_haqq_bot
npm i && npm start
```
# use bot 
go to https://t.me/Cosmos_haqq_bot
- Start the bot with the command /start , then select the node type you want to support

![image](https://user-images.githubusercontent.com/80441573/236667138-ce51dae1-6a51-4c24-89a0-84da55e85a17.png)

- Take turns looking for what you like

![image](https://user-images.githubusercontent.com/80441573/236667193-a9871afb-cffa-4ca3-ba74-6ad49e999ac3.png)
![image](https://user-images.githubusercontent.com/80441573/236667226-3cf6f794-6e01-43e5-934d-241fc0260ec1.png)
![image](https://user-images.githubusercontent.com/80441573/236667250-d009da05-0049-4d15-a53a-9602e02c2c49.png)

