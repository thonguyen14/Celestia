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

# Public trusted node RPC address
# PUBLIC_TRUSTED_RPC="https://rpc-blockspacerace.pops.one"
PUBLIC_TRUSTED_RPC="https://rpc-blockspacerace.pops.one"

# Your public IP
ip=$(wget -qO- eth0.me)

touch $LOG_FILE

# Collect status of node
DA_BLOCK_HEIGHT=$(curl https://rpc-blockspacerace.pops.one/block | jq -r '.result.block.header.height')
STATUS=$(curl -s https://leaderboard.celestia.tools/api/v1/nodes/$CEL_NODEID  | jq)
CATCHING_UP=$(echo $STATUS | jq '.result.sync_info.catching_up')
LATEST_BLOCK=$(echo $STATUS | jq '.result.sync_info.latest_block_height' | xargs )
VOTING_POWER=$(echo $STATUS | jq '.result.validator_info.voting_power' | xargs )
ADDRESS=$(echo $STATUS | jq '.result.validator_info.address' | xargs )

# Collect node version
NODE_VERSION=$(curl -s "$NODE_RPC/abci_info" | jq .result.response.version | tr -d \\ | tr -d '"')
TRUSTED_RPC_VERSION=$(curl -s "$PUBLIC_TRUSTED_RPC//abci_info" --connect-timeout 20 | jq .result.response.version | tr -d \\ | tr -d '"')

# Collect validator status
VAL_STATUS=$(curl -s $GURU_API | jq .jailed)

source $LOG_FILE
echo 'LAST_BLOCK="'"$LATEST_BLOCK"'"' > $LOG_FILE
echo 'LAST_POWER="'"$VOTING_POWER"'"' >> $LOG_FILE


source $HOME/.bash_profile
curl -s "$NODE_RPC/status"> /dev/null
if [[ $? -ne 0 ]]; then
    MSG="Node $NODE_NAME with $ip is stopped!!!.To restart run command : sudo systemctl restart haqqd"
    SEND=$(curl -s -X POST -H "Content-Type:multipart/form-data" "https://api.telegram.org/bot$TG_API/sendMessage?chat_id=$TG_ID&text=$MSG"); exit 1
fi

if [ "$NODE_VERSION" != "$TRUSTED_RPC_VERSION" ]; then
    MSG="Node $NODE_NAME with $ip Correct version is $TRUSTED_RPC_VERSION!!!. pleasure Upgrade following guide in the link https://github.com/thonguyen14/Haqqd/tree/main/upgrade/355555"
    SEND=$(curl -s -X POST -H "Content-Type:multipart/form-data" "https://api.telegram.org/bot$TG_API/sendMessage?chat_id=$TG_ID&text=$MSG");
fi

if [[ $VAL_STATUS = "true" ]]; then
    MSG=" Node $NODE_NAME with $ip is jailed !!!.To unjail , run command : haqqd tx slashing unjail --broadcast-mode=block --from=<wallet-name> --chain-id=haqq_54211-2 --gas=auto -y"
    SEND=$(curl -s -X POST -H "Content-Type:multipart/form-data" "https://api.telegram.org/bot$TG_API/sendMessage?chat_id=$TG_ID&text=$MSG");
fi

if [[ $LAST_POWER -ne $VOTING_POWER ]]; then
    DIFF=$(($VOTING_POWER - $LAST_POWER))
    if [[ $DIFF -gt 0 ]]; then
        DIFF="%2B$DIFF"
    fi
    MSG="Node $NODE_NAME with $ip has changed voting power: $DIFF%0A($LAST_POWER -> $VOTING_POWER)"
    SEND=$(curl -s -X POST -H "Content-Type:multipart/form-data" "https://api.telegram.org/bot$TG_API/sendMessage?chat_id=$TG_ID&text=$MSG");
fi

if [[ $LAST_BLOCK -ge $LATEST_BLOCK ]]; then
    MSG="Node $NODE_NAME with $ip got probably stuck at block $LATEST_BLOCK"
    SEND=$(curl -s -X POST -H "Content-Type:multipart/form-data" "https://api.telegram.org/bot$TG_API/sendMessage?chat_id=$TG_ID&text=$MSG");
fi

if [[ $VOTING_POWER -lt 1 ]]; then
    MSG="Node $NODE_NAME with $ip is inactive\jailed. Voting power $VOTING_POWER . CHECK JAIL or TOMBSTONE STATUS :  haqqd query slashing signing-info (haqqd tendermint show-validator)      CHECK ACTIVE/INACTIVE STATUS : haqqd query staking validators -oj --limit=2000 | jq '.validators[] | select(.operator_address=="VALIDATOR_ADDR").status' "
    SEND=$(curl -s -X POST -H "Content-Type:multipart/form-data" "https://api.telegram.org/bot$TG_API/sendMessage?chat_id=$TG_ID&text=$MSG");
fi

if [[ $CATCHING_UP = "true" ]]; then
    MSG=" Node $NODE_NAME with $ip is not full synched, catching up. $LATEST_BLOCK -> $REAL_BLOCK"
    SEND=$(curl -s -X POST -H "Content-Type:multipart/form-data" "https://api.telegram.org/bot$TG_API/sendMessage?chat_id=$TG_ID&text=$MSG");
fi

if [[ $REAL_BLOCK -eq 0 ]]; then
    MSG="Can't connect to $PUBLIC_TRUSTED_RPC"
    SEND=$(curl -s -X POST -H "Content-Type:multipart/form-data" "https://api.telegram.org/bot$TG_API/sendMessage?chat_id=$TG_ID&text=$MSG");

fi

touch $LOG_SESSION
echo "Subject: List of login session to your server" > $LOG_SESSION
last -s today >> $LOG_SESSION
MSG="Last login session in today: `last -s today | awk '{print $3}' |grep ^[0-9] | tr '\t' ' '`"
SEND=$(curl -s -X POST -H "Content-Type:multipart/form-data" "https://api.telegram.org/bot$TG_API/sendMessage?chat_id=$TG_ID&text=$MSG");
