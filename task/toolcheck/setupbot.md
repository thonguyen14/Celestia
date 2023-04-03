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

![image](https://user-images.githubusercontent.com/80441573/229411886-fee14836-2888-4a23-aed2-5b5945a1d672.png)

- Take turns looking for what you like

![image](https://user-images.githubusercontent.com/80441573/229412097-aa13dca6-1482-41d7-bbf2-35c49062fc04.png)

