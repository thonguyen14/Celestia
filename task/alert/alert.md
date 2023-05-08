###Simple instructions to set up a notification system that sends node information and tips to Telegram Bot . Take for example celestia-light
# Create Telegram bot
- Using [@BotFather](https://t.me/BotFather) go to /newbot to create your BOT, then store HTTP API of your BOT carefully
![image](https://user-images.githubusercontent.com/80441573/194982631-aea4b52c-33fe-475c-b6f5-50f9f6abd06c.png)
- Set environment variable for your API BOT
```
echo export TG_API='5792628568:AA*****************-sJAsIGpfD6Eozoc' >> $HOME/.bash_profile
source $HOME/.bash_profile
```
- Create your own Telegram group, then add the bot to the group as Administrator, send a message in your Tele group.

- Set environment variable for chat ID of your Tele group
```
TG_ID=$(curl -s https://api.telegram.org/bot$TG_API/getUpdates| jq | grep "\"id\"" |tail -n 1 |awk '{print $2}' | tr -d ",")
echo export TG_ID=$TG_ID >> $HOME/.bash_profile
source $HOME/.bash_profile
```
# Install script of alert-tele
```
mkdir $HOME/.alert-tele/ && cd $HOME/.alert-tele/
wget -O alert.sh https://raw.githubusercontent.com/thonguyen14/Celestia/main/task/alert/alert.sh
```
# Edit alert-tele.sh file following your chain
```
vi $HOME/.alert-tele/alert-tele.sh
```
```
# If alert script and your node are in different machine, you have to expose your RPC node to public internet. then replace YOUR_RPC="http://YOUR_NODE_IP:YOUR_RPC_PORT"
if alert and your node are in one machine YOUR_RPC="http://127.0.0.1:YOUR_RPC_PORT"

# set CEL_NODEID
example : CEL_NODEID="12D3KooWK4GsbLLDPV8KPeAP1kma8ebfF2ZPomp8JMYcbXBL6ZXt"

# Select a public trusted RPC as standard node to compare
example : TRUSTED_RPC="https://rpc-blockspacerace.pops.one"

# name the alert string
example : YOUR_NODE_NAME="celestia-light"

```

# Run crontab as command
```
crontab -e -u root
* * * * *  /bin/bash $HOME/.alert-tele/alert.sh
```
- Stop your node, then check Telegram Bot

![image](https://user-images.githubusercontent.com/80441573/236758715-f9f1cfac-b735-4c33-9086-457f04dc8038.png)
