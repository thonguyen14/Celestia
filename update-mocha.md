# Stop celestia-appd
````
sudo systemctl stop celestia-appd
```

# edit chain in bash_profile to mocha

````
vi $HOME/.bash_profile
````
# set necessary vars
```
CHAIN_ID="mocha"
NODE_MONIKER=$(cat "$HOME/.celestia-app/config/config.toml" | grep moniker | grep -oP 'moniker = "\K[^"]+')
```
# backup priv_validator_key.json from mamaki (optional)
```
cp $HOME/.celestia-app/config/priv_validator_key.json $HOME/priv_validator_key.json.backup
```
# remove mamaki testnet data
````
rm -rf $HOME/.celestia-app
rm -rf $HOME/celestia-app
rm -rf networks
sudo rm "$(which celestia-appd)"
````
# install mocha testnet
````
cd $HOME
rm -rf celestia-app
git clone https://github.com/celestiaorg/celestia-app.git
cd celestia-app
git checkout v0.11.0
make install
celestia-appd version
````
# setup the P2P Networks by cloning the networks repository
````
cd $HOME
rm -rf networks
git clone https://github.com/celestiaorg/networks.git
````
# initialize the network
````
celestia-appd config keyring-backend test
celestia-appd config chain-id $CHAIN_ID
celestia-appd init "$NODE_MONIKER" --chain-id $CHAIN_ID
````
# Copy the genesis.json file
````
cp $HOME/networks/mocha/genesis.json $HOME/.celestia-app/config
````
# quick-sync with snapshot (  Optional )
````
cd $HOME
rm -rf ~/.celestia-app/data
mkdir -p ~/.celestia-app/data
SNAP_NAME=$(curl -s https://snaps.qubelabs.io/celestia/ | \
    egrep -o ">mocha.*tar" | tr -d ">")
wget -O - https://snaps.qubelabs.io/celestia/${SNAP_NAME} | tar xf - \
    -C ~/.celestia-app/data/
````
# set seed , peer ...
```
curl -s https://raw.githubusercontent.com/celestiaorg/networks/master/mocha/genesis.json > $HOME/.celestia-app/config/genesis.json
sha256sum $HOME/.celestia-app/config/genesis.json # 05ef265e16f37d1f5aa2ec884be3782c38d71e59a6d57957235c5ca433aa8e05

sed -i 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.0001utia"|g' $HOME/.celestia-app/config/app.toml

seeds=$(curl -sL https://raw.githubusercontent.com/celestiaorg/networks/master/mocha/seeds.txt | tr -d '\n')
peers=$(curl -sL https://raw.githubusercontent.com/celestiaorg/networks/master/mocha/peers.txt | tr -d '\n')
sed -i -e 's|^seeds *=.*|seeds = "'$seeds'"|; s|^persistent_peers *=.*|persistent_peers = "'$peers'"|' $HOME/.celestia-app/config/config.toml
````
# in case of pruning
````
sed -i 's|pruning = "default"|pruning = "custom"|g' $HOME/.celestia-app/config/app.toml
sed -i 's|pruning-keep-recent = "0"|pruning-keep-recent = "100"|g' $HOME/.celestia-app/config/app.toml
sed -i 's|pruning-interval = "0"|pruning-interval = "17"|g' $HOME/.celestia-app/config/app.toml
````
# restore priv_validator_key.json from mamaki (optional)
mv $HOME/priv_validator_key.json.backup $HOME/.celestia-app/config/priv_validator_key.json
# add key
````
celestia-appd keys add <NAME-ADD> --recover
````
# RESTART
````
sudo systemctl restart celestia-appd && journalctl -u celestia-appd -f -o cat
````
