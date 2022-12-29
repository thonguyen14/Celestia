# Update packages if needed 
```
sudo apt update && sudo apt upgrade -y 
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu -y
```
# install go
```
ver="1.19.1"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile

go version
```
6. Download and build binaries 
```
cd $HOME
rm -rf celestia-app
git clone https://github.com/celestiaorg/celestia-app.git
cd celestia-app/
APP_VERSION=v0.6.0
git checkout tags/$APP_VERSION -b $APP_VERSION
make install
cd $HOME
```
# Save and import variables into system ( lưu và nhập các biến vào hệ thống )
 ```
 CELESTIA_CHAIN="mamaki"
 CELESTIA_NODENAME="thonguyen"
 CELESTIA_WALLET="thonguyen"
echo "
export CELESTIA_CHAIN=${CELESTIA_CHAIN}
export CELESTIA_NODENAME=${CELESTIA_NODENAME}
export CELESTIA_WALLET=${CELESTIA_WALLET}
" >> $HOME/.bash_profile && source $HOME/.bash_profile
```
# Init and config app
```
celestia-appd init $CELESTIA_NODENAME --chain-id $CELESTIA_CHAIN
celestia-appd config chain-id $CELESTIA_CHAIN
celestia-appd config keyring-backend test
```
# Update genesis 
```
wget -O $HOME/.celestia-app/config/genesis.json "https://github.com/celestiaorg/networks/raw/master/mamaki/genesis.json"

# Or: cp $HOME/networks/$CHAIN_ID/genesis.json $HOME/.celestia-app/config
```
# Download network tools 
```
cd $HOME
rm -rf networks
git clone https://github.com/celestiaorg/networks.git
```
# Set seeds, peers and boot nodes
```
BOOTSTRAP_PEERS=$(curl -sL https://raw.githubusercontent.com/celestiaorg/networks/master/mamaki/bootstrap-peers.txt | tr -d '\n')
MY_PEER=$(celestia-appd tendermint show-node-id)@$(curl -s ifconfig.me)$(grep -A 9 "\[p2p\]" ~/.celestia-app/config/config.toml | egrep -o ":[0-9]+")
PEERS=$(curl -sL https://raw.githubusercontent.com/celestiaorg/networks/master/mamaki/peers.txt | tr -d '\n' | head -c -1 | sed s/"$MY_PEER"// | sed "s/,,/,/g")
sed -i.bak -e "s/^bootstrap-peers *=.*/bootstrap-peers = \"$BOOTSTRAP_PEERS\"/" $HOME/.celestia-app/config/config.toml
sed -i.bak -e "s/^persistent-peers *=.*/persistent-peers = \"$PEERS\"/" $HOME/.celestia-app/config/config.toml
```
# Set minimum gas price
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0utia\"/" $HOME/.celestia-app/config/app.toml
```
# Use custom settings 
 ```
use_legacy="false"
pex="true"
max_connections="90"
peer_gossip_sleep_duration="2ms"
sed -i.bak -e "s/^use-legacy *=.*/use-legacy = \"$use_legacy\"/" $HOME/.celestia-app/config/config.toml
sed -i.bak -e "s/^pex *=.*/pex = \"$pex\"/" $HOME/.celestia-app/config/config.toml
sed -i.bak -e "s/^max-connections *=.*/max-connections = \"$max_connections\"/" $HOME/.celestia-app/config/config.toml
sed -i.bak -e "s/^peer-gossip-sleep-duration *=.*/peer-gossip-sleep-duration = \"$peer_gossip_sleep_duration\"/" $HOME/.celestia-app/config/config.toml
sed -i.bak -e 's|^laddr = \"tcp:\/\/.*:\([0-9].*\)57\"|laddr = \"tcp:\/\/0\.0\.0\.0:\157\"|' $HOME/.celestia-app/config/config.toml
```
# Enable prometheus 
```
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.celestia-app/config/config.toml
```
# Config pruning 
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="5000"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.celestia-app/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.celestia-app/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.celestia-app/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.celestia-app/config/app.toml
```
# Set timeouts
```
sed -i.bak -e "s/^timeout-commit *=.*/timeout-commit = \"25s\"/" $HOME/.celestia-app/config/config.toml
sed -i.bak -e "s/^timeout-propose *=.*/timeout-propose = \"3s\"/" $HOME/.celestia-app/config/config.toml
sed -i.bak -e "s/^skip-timeout-commit *=.*/skip-timeout-commit = false/" $HOME/.celestia-app/config/config.toml
```
# Increse peer connections
```
sed -i.bak -e "s/^max-connections *=.*/max-connections = 150/" $HOME/.celestia-app/config/config.toml
sed -i.bak -e "s/^max-num-inbound-peers *=.*/max-num-inbound-peers = 100/" $HOME/.celestia-app/config/config.toml
sed -i.bak -e "s/^max-num-outbound-peers *=.*/max-num-outbound-peers = 50/" $HOME/.celestia-app/config/config.toml
sed -i.bak -e "s/^max-incoming-connection-attempts *=.*/max-incoming-connection-attempts = 20/" $HOME/.celestia-app/config/config.toml
```
# Set validator mode
```
sed -i.bak -e "s/^mode *=.*/mode = \"validator\"/" $HOME/.celestia-app/config/config.toml
```
# Set gustom ports in app.toml file ( You can customize it to your liking)
````
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CELESTIA_PORT}317\"%;
s%^address = \":8080\"%address = \":${CELESTIA_PORT}080\"%;
s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${CELESTIA_PORT}090\"%; 
s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${CELESTIA_PORT}091\"%; 
s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${CELESTIA_PORT}545\"%; 
s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${CELESTIA_PORT}546\"%" $HOME/.celestia-app/config/app.toml
````
# Set gustom ports in config.toml file ( You can customize it to your liking )
````
sed -i.bak -e "s%^proxy-app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CELESTIA_PORT}658\"%; 
s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${CELESTIA_PORT}657\"%; 
s%^pprof-laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CELESTIA_PORT}060\"%;
s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CELESTIA_PORT}656\"%;
s%^external-address = \"\"%external_address = \"$(wget -qO- eth0.me):${CELESTIA_PORT}656\"%;
s%^prometheus-listen-addr = \":26660\"%prometheus_listen_addr = \":${CELESTIA_PORT}660\"%" $HOME/.celestia-app/config/config.toml
````
# (Không bắt buộc) Use Quick Sync by restoring data from snapshot
```
cd $HOME
rm -rf ~/.celestia-app/data
mkdir -p ~/.celestia-app/data
SNAP_NAME=$(curl -s https://snaps.qubelabs.io/celestia/ | egrep -o ">mamaki.*tar" | tr -d ">")
wget -O - https://snaps.qubelabs.io/celestia/${SNAP_NAME} | tar xf - -C ~/.celestia-app/data/
```
# Create service
```
sudo tee /etc/systemd/system/celestia-appd.service > /dev/null << EOF
[Unit]
  Description=CELESTIA MAMAKI
  After=network-online.target
[Service]
  User=$USER
  ExecStart=$(which celestia-appd) start
  Restart=on-failure
  RestartSec=10
  LimitNOFILE=65535
[Install]
  WantedBy=multi-user.target
EOF
```
```
sudo systemctl enable celestia-appd
sudo systemctl daemon-reload
sudo systemctl restart celestia-appd && journalctl -u celestia-appd -f -o cat
```
# Create a Wallet
```
 celestia-appd keys add YOUR_WALLET_NAME
 or :
 celestia-appd keys add YOUR_WALLET_NAME --recover
```
- check all your wallets 
```
celestia-appd keys list
```
# to discord faucet 

request celestia1s5cf5qeu9rx3reajvyvd2kr54hc79379j7zz6z

# check sync status if "catching_up” = false ok
```
celestia-appd status 2>&1 | jq .SyncInfo
or:
curl -s localhost:23657/status | jq '.result."sync_info",.result."validator_info",.result."node_info"."network"'

```
# Create Validator
```
celestia-appd tx staking create-validator \
--amount=9000000utia \
--pubkey=$(celestia-appd tendermint show-validator) \
--moniker=$CELESTIA_NODENAME \
--chain-id=$CELESTIA_CHAIN \
--commission-rate=0.1 \
--commission-max-rate=0.2 \
--commission-max-change-rate=0.01 \
--min-self-delegation="1" \
--from=$CELESTIA_WALLET \
--node https://rpc-mamaki.pops.one/
-y
```
- check validator in https://celestia.explorers.guru/ or run command
```
celestia-appd q staking validator <VALOPER_ADDR>
``` 
# delete node
```
sudo systemctl stop celestia-appd && sudo systemctl disable celestia-appd
rm -rf /etc/systemd/system/celestia-appd.service 
rm -rf $HOME/go/bin/celestia-appd
rm -rf /root/celestia-app/
rm -rf /root/.celestia-app/
sed -i "/CELESTIA_/d" $HOME/.bash_profile
```
# some useful commands
- check balance 
```
celestia-appd q bank balances <wallet-address>
celestia-appd q bank balances celestia1s5cf5qeu9rx3reajvyvd2kr54hc79379j7zz6z
```
- show wallet 
```
celestia-appd keys show YOUR_WALLET_NAME --bech=acc  
example :
celestia-appd keys show tho248 --bech=acc
```
- deleta wallet
````
celestia-appd keys delete $CELESTIA_WALLET
````
- show validator wallet 
```
celestia-appd keys show YOUR_WALLET_NAME --bech=val      
example :
celestia-appd keys show thonguyen --bech=val
```
- check moniker name 
```
 celestia-appd status 2>&1 | jq .NodeInfo
```
- check validator info
````
celestia-appd status 2>&1 | jq .ValidatorInfo

#example 
celestia-appd q staking validator $(celestia-appd keys show wtho --bech val -a) --node="http://127.0.0.1:23657"
````
- unjail
```
celestia-appd tx slashing unjail --broadcast-mode=block --from=<WALLET-NAME> --chain-id=mamaki --node="http://127.0.0.1:23657" --gas=auto -y
```
- Edit validator
````
celestia-appd tx staking edit-validator \
  --moniker=$NODENAME \
  --identity=<your_keybase_id> \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id=$CELESTIA_CHAIN_ID \
  --from=$CELESTIA_WALLET
  ````
- your node peers
````
echo $(celestia-appd tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.celestia-app/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
````
- get currently conected peers lis
````
curl -sS http://localhost:${CELESTIA_PORT}657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
````
- Delegate to validator from a wallet
```
celestia-appd tx staking delegate YOUR_VALIDATOR_ADDRESS 10000000utia --from=YOUR_WALLETNAME --chain-id=mamaki --keyring-backend test  --node="http://127.0.0.1:23657" -y

 Example:
 celestia-appd tx staking delegate celestiavaloper1s5cf5qeu9rx3reajvyvd2kr54hc79379hpqmvy 10000000utia --from=thonguyen --chain-id=mamaki --keyring-backend test --node https://rpc-mamaki.pops.one/ -y
```
- Redelegate stake to another validator
````
celestia-appd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 1000000utia --from $CELESTIA_WALLET --chain-id $CELESTIA_CHAIN_ID --gas auto --gas-adjustment 1.5
````
- send
```
celestia-appd tx bank send celestia1d7y9ray68r94khyz389dx5jhfygpg5hrt93vcc celestia1s5cf5qeu9rx3reajvyvd2kr54hc79379j7zz6z 1000000utia --chain-id mamaki  --from thonguyen --gas-prices 0.1utia --gas-adjustment 1.5 --gas auto -y
```
- vote
````
celestia-appd tx gov vote 1 yes --from $CELESTIA_WALLET --chain-id $CELESTIA_CHAIN_ID
````
- Withdraw all rewards
````
celestia-appd tx distribution withdraw-all-rewards --from $CELESTIA_WALLET --chain-id $CELESTIA_CHAIN_ID --gas auto --gas-adjustment 1.3
````
- Withdraw rewards with commision
````
celestia-appd tx distribution withdraw-rewards $CELESTIA_VALOPER_ADDRESS --from $CELESTIA_WALLET --commission --chain-id $CELESTIA_CHAIN_ID --gas auto --gas-adjustment 1.3
````
- check chain-id in genesis.json and client.toml
```
cat .celestia-app/config/genesis.json | grep chain_id
cat .celestia-app/config/client.toml | grep chain
```


