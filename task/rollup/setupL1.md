**Instructions for setting up Cosmos SDK Appchain L1 into Cosmos SDK Rollup on Celestia . The scripts for this tutorial are built for Celestia's Blockspacerace testnet**
**install Celestia light node , Instructions link [here](https://docs.celestia.org/nodes/light-node/)
# firts download repo of Cosmos SDK Appchain L1 , here I take the example Sei network
```
git clone https://github.com/sei-protocol/sei-chain.git
cd sei-chain
git checkout master; git pull --tags --force; git checkout tags/1.2.2beta-postfix && make install
```
# check sdk version 
```
cd sei-chain
cat go.mod | grep "github.com/cosmos/cosmos-sdk" | awk '{print $2}' | awk -F: '{print $1"."$2}'
```
#Select latest Rollkit SDK version from the [link](https://github.com/rollkit/cosmos-sdk/tags) which is consistent with your $SDK_VERSION
#If sdk version=0.45 => select v0.45.10-rollkit-v0.7.3-no-fraud-proofs
#If sdk version=0.46 => select v0.46.7-rollkit-v0.7.3-no-fraud-proofs

# Edit Cosmos-SDK appchain to be Cosmos SDK rollup (Suppose $SDK_VERSION=v0.46.7)
```
cd sei-chain
go mod edit -replace github.com/cosmos/cosmos-sdk=github.com/rollkit/cosmos-sdk@vv0.46.7-rollkit-v0.7.3-no-fraud-proofs
go mod edit -replace github.com/tendermint/tendermint=github.com/celestiaorg/tendermint@v0.34.22-0.20221202214355-3605c597500d
go mod tidy
go mod download
make install
```
# Setting Cosmos SDK Rollup
- **Setup some variables**
```
MONIKER_NAME="YOUR_NAME"  #ex : MONIKER_NAME="thonguyen"
CHAIN_ID="atlantic-2"
KEY_NAME_1=key1
KEY_NAME_2=key2
DENOM="usei"
CHAINFLAG="--chain-id ${CHAIN_ID}"
TOKEN_AMOUNT="10000000000000000000000000${DENOM}"
STAKING_AMOUNT="10000000${DENOM}"
HOME_DIR="/root/.sei" 
```
- ***reset any existing genesis/chain data***
```
seid tendermint unsafe-reset-all
```
- ***initialize the validator with the chain ID you set***
```
seid init $MONIKER_NAME --chain-id $CHAIN_ID
```
- ***add keys for key 1 and key 2 to keyring-backend test***
```
seid keys add $KEY_NAME_1 --keyring-backend test
seid keys add $KEY_NAME_2 --keyring-backend test
```
- ***set DENOM go to genesis file***
```
sed -i.bak -e "s|\"stake\"|\"$DENOM\"|g" ${HOME_DIR}/config/genesis.json
```
- ***add these as genesis accounts***
```
seid add-genesis-account $KEY_NAME_1 $TOKEN_AMOUNT --keyring-backend test
seid add-genesis-account $KEY_NAME_2 $TOKEN_AMOUNT --keyring-backend test
```
- ***set the staking amounts in the genesis transaction***
```
seid gentx $KEY_NAME_1 $STAKING_AMOUNT --chain-id $CHAIN_ID --keyring-backend test
```
- ***collect genesis transactions***
```
seid collect-gentxs
```
# Start rollup chain
- ***Create a random Namespace ID for your rollup to post blocks to***
```
NAMESPACE_ID=$(echo $RANDOM | md5sum | head -c 16; echo;)
echo $NAMESPACE_ID 
```
- ***Query the DA Layer start height, in this case we are querying blockheight from RPC of a consensus fullnode on Celestia-Blockspacerace***
#You can check public of Celestia RPC at [here](https://docs.celestia.org/nodes/blockspace-race/#rpc-endpoints)
```
DA_BLOCK_HEIGHT=$(curl https://rpc-blockspacerace.pops.one/block | jq -r '.result.block.header.height')
echo $DA_BLOCK_HEIGHT
```
- ***start a sequencer of rollkit chain***
#If DA node and Rollup sequencer are on different server change http://localhost:26659 to http://YOUR_PUB_IP:26659
```
seid start --rollkit.aggregator true --rollkit.block_time 2.35s --rollkit.da_block_time 2.35s --rollkit.da_layer celestia --rollkit.da_config='{"base_url":"http://localhost:26659","timeout":60000000000,"fee":100,"gas_limit":100000}' --rollkit.namespace_id $NAMESPACE_ID  --rollkit.da_start_height $DA_BLOCK_HEIGHT --p2p.laddr "0.0.0.0:26656" --p2p.seed_mode --log_level debug
```

![image](https://user-images.githubusercontent.com/80441573/235969362-12a03856-5bd8-46b2-99c4-b7fbe38a62a2.png)

![image](https://user-images.githubusercontent.com/80441573/235969842-c63fa3ea-d39b-485d-ae5c-731928e9387b.png)
