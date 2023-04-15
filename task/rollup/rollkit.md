**make sure you have Celestia light node installed. Instructions link [here](https://docs.celestia.org/nodes/light-node/)

**instructions rollkit from team celeatia [here](https://rollkit.dev/docs/tutorials/gm-world/)
# install prerequisites
## install extras
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu -y
```
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
#check
sudo docker logs -f CONTAINER_ID_or_NAME
```
- **useful commands**
 - *check balance*
 ```
 curl -s -X GET http://0.0.0.0:26659/balance | jq
 ```
  - *Find the Container ID*
  ```
  docker ps
  docker ps -a  (include stop the container)
  ```
   - *stop , start , delete docker CONTAINER* 
   ```
   docker stop CONTAINER_ID_or_NAME
   docker start CONTAINER_ID_or_NAME
   docker rm CONTAINER_ID_or_NAME
   ```
# Install Ignite CLI
```
curl https://get.ignite.com/cli! | bash
#check version
ignite version
```
![image](https://user-images.githubusercontent.com/80441573/232179338-05f19800-55e2-46ce-a56e-64918791c09b.png)

```
cd $HOME
screen -S GM
ignite scaffold chain gm --address-prefix gm
```
![image](https://user-images.githubusercontent.com/80441573/232179552-b7936138-33ab-481b-83b5-d87c5449d326.png)
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
cd
screen -S rollkit
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
![image](https://user-images.githubusercontent.com/80441573/232205794-95ebb1a4-9b9d-4e73-87ee-0b6d81323f69.png)

ctrl+a+d--> enter

# Start your sovereign rollup
## edit query_gm.go
```
cd gm/x/gm/keeper
vi query_gm.go
```
#enter the below
```
func (k Keeper) Gm(goCtx context.Context, req *types.QueryGmRequest) (*types.QueryGmResponse, error) {
    if req == nil {
        return nil, status.Error(codes.InvalidArgument, "invalid request")
    }
    ctx := sdk.UnwrapSDKContext(goCtx)
    _ = ctx
    return &types.QueryGmResponse{Text: "gm world!"}, nil
}
```
**Before starting our rollup, we'll need to find and change *FlagIAVLFastNode* to *FlagDisableIAVLFastNode***
in gm/cmd/gmd/cmd/root.go
baseapp.SetIAVLDisableFastNode(cast.ToBool(appOpts.Get(server.FlagDisableIAVLFastNode)))

baseapp.SetIAVLDisableFastNode(cast.ToBool(appOpts.Get(server.FlagDisableIAVLFastNode))),
```
cd
cd gm/cmd/gmd/cmd
vi root.go
```
cd gm
wget -O init-testnet.sh https://raw.githubusercontent.com/rollkit/docs/main/docs/scripts/gm/init-testnet.sh && chmod +x init-testnet.sh
cd $HOME
sudo rm -r go/bin/gmd && rm -rf .gm
screen -x rollkit
ctrl+c
cd
screen -S rollup
cd gm
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

