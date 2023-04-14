**make sure you have Celestia light node installed. Instructions link [here](https://docs.celestia.org/nodes/light-node/)
**instructions from team celeatia [here](https://rollkit.dev/docs/tutorials/gm-world/)
# install prerequisites
## Install Docker
```
wget -O get-docker.sh https://get.docker.com 
sudo sh get-docker.sh
rm -f get-docker.sh 
docker --version
```
## Install golang
```
ver="1.19.3"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
```
# run the local-celestia-devnet whit docker
```
docker run --platform linux/amd64 -p 26650:26657 -p 16659:16659 ghcr.io/celestiaorg/local-celestia-devnet:main
sudo docker logs -f jolly_keldysh
```
- useful commands
 - check balance
 ```
 curl -s -X GET http://0.0.0.0:26659/balance | jq
 ```
  - Find the Container ID
  ```
  docker ps
  docker ps -a  (include stop the container)
  ```
   - stop , start , delete docker CONTAINER 
   ```
   docker stop CONTAINER_ID_or_NAME
   docker start CONTAINER_ID_or_NAME
   docker rm CONTAINER_ID_or_NAME
   ```
# Install Ignite CLI
```
curl https://get.ignite.com/cli! | bash
ignite version
```
```
cd $HOME
screen -S GM
ignite scaffold chain gm --address-prefix gm
```
***crrl+a+d --> enter***
# To swap out Tendermint for Rollkit
```
cd gm
go mod edit -replace github.com/cosmos/cosmos-sdk=github.com/rollkit/cosmos-sdk@v0.46.7-rollkit-v0.7.3-no-fraud-proofs
go mod edit -replace github.com/tendermint/tendermint=github.com/celestiaorg/tendermint@v0.34.22-0.20221202214355-3605c597500d
go mod tidy
go mod download
```
# Start your rollup
```
cd gm
wget -O init-local.sh https://raw.githubusercontent.com/rollkit/docs/main/docs/scripts/gm/init-local.sh && chmod +x init-local.sh && ./init-local.sh
```
- check list key
```
gmd keys list --keyring-backend test
```
- set key in to bash
```
echo "export KEY1=gm1xxxxx" >> $HOME/.bash_profile
echo "export KEY2=gm1xxxxx" >> $HOME/.bash_profile
source $HOME/.bash_profile
```
- test sending a transaction 
```
gmd tx bank send $KEY1 $KEY2 42069stake --keyring-backend test -y
```
- query balance
```
gmd query bank balances $KEY1
gmd query bank balances $KEY2
```
# Install Ignite CLI on Linux
## Create your first query
```
cd $HOME
screen -S gm-world
cd gm
ignite scaffold query gm --response text
```
ctrl+a+d--> enter
# Start your sovereign rollup
**Before starting our rollup, we'll need to find and change *FlagIAVLFastNode* to *FlagDisableIAVLFastNode***
in gm/cmd/gmd/cmd/root.go
baseapp.SetIAVLDisableFastNode(cast.ToBool(appOpts.Get(server.FlagDisableIAVLFastNode))),
```
cd gm
wget -O init-testnet.sh https://raw.githubusercontent.com/rollkit/docs/main/docs/scripts/gm/init-testnet.sh && chmod +x init-testnet.sh
cd $HOME
rm -r go/bin/gmd && rm -rf .gm
./init-testnet.sh
````
- check query
```
cd $HOME
screen -S query
gmd q gm gm
#output
text: gm world!
```
**OK OK**

