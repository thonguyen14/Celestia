#!/bin/bash

# File name for saving parameters
LOG_FILE="$HOME/.alert-tele/alert-tele.log"

# File name stores login session in today
LOG_SESSION="$HOME/.alert-tele/logsession.log"

# Your node RPC address, e.g. "http://127.0.0.1:26657"
NODE_RPC="http://127.0.0.1:26657"

# Your NODEID
CEL_NODEID="12D3KooWK4GsbLLDPV8KPeAP1kma8ebfF2ZPomp8JMYcbXBL6ZXt"
CEL_API="https://leaderboard.celestia.tools/api/v1/nodes/$CEL_NODEID"

# YOUR node name
NODE_NAME="celestia-light"

source

# Your public IP
ip=$(wget -qO- eth0.me)

touch $LOG_FILE

# Collect status of node
STATUS=$(curl -s https://leaderboard.celestia.tools/api/v1/nodes/$CEL_NODEID)
network_height=$(echo $STATUS | jq .network_height)
Uptime_Score=$(echo $STATUS | jq .uptime)
Node_Uptime=$(echo $STATUS | jq .last_accumulative_node_runtime_counter_in_seconds)
Head=$(echo $STATUS | jq .head )
Total_Sampled_Headers=$(echo $STATUS | jq .das_total_sampled_headers )
PayForBlob_Count=$(echo $STATUS | jq .pfb_count )

# Collect node version
NODE_VERSION=$(celestia version)

source $LOG_FILE
echo 'network_height="'"$network_height"'"' > $LOG_FILE
echo 'Head="'"$Head"'"' >> $LOG_FILE


source $HOME/.bash_profile
curl -s "$CEL_API"> /dev/null
if [[ $? -ne 0 ]]; then
    MSG="Node $NODE_NAME with $ip is stopped!!!.To restart run command : sudo systemctl restart celestia-light"
    SEND=$(curl -s -X POST -H "Content-Type:multipart/form-data" "https://api.telegram.org/bot$TG_API/sendMessage?chat_id=$TG_ID&text=$MSG"); exit 1
fi

if [[ $Uptime_Score = "<95" ]]; then
    MSG=" Node $NODE_NAME with $ip is uptime warning !!!.To check your node 
    SEND=$(curl -s -X POST -H "Content-Type:multipart/form-data" "https://api.telegram.org/bot$TG_API/sendMessage?chat_id=$TG_ID&text=$MSG");
fi

if [[ $Head = "$Head" ]]; then
    MSG="Node $NODE_NAME with $ip got at $Head"
    SEND=$(curl -s -X POST -H "Content-Type:multipart/form-data" "https://api.telegram.org/bot$TG_API/sendMessage?chat_id=$TG_ID&text=$MSG");
fi

if [[ $Total_Sampled_Headers = "$Total_Sampled_Headers" ]]; then
    MSG="Node $NODE_NAME with $ip is got a $Total_Sampled_Headers
    SEND=$(curl -s -X POST -H "Content-Type:multipart/form-data" "https://api.telegram.org/bot$TG_API/sendMessage?chat_id=$TG_ID&text=$MSG");
fi

if [[ $PayForBlob_Count = "$PayForBlob_Count" ]]; then
    MSG=" Node $NODE_NAME with $ip is submited $PayForBlob_Count transactions
    SEND=$(curl -s -X POST -H "Content-Type:multipart/form-data" "https://api.telegram.org/bot$TG_API/sendMessage?chat_id=$TG_ID&text=$MSG");
fi

touch $LOG_SESSION
echo "Subject: List of login session to your server" > $LOG_SESSION
last -s today >> $LOG_SESSION
MSG="Last login session in today: `last -s today | awk '{print $3}' |grep ^[0-9] | tr '\t' ' '`"
SEND=$(curl -s -X POST -H "Content-Type:multipart/form-data" "https://api.telegram.org/bot$TG_API/sendMessage?chat_id=$TG_ID&text=$MSG");
