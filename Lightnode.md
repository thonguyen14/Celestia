Arabica
# Update if needed
```
sudo apt update && sudo apt upgrade -y
```
# Insall packages
```
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu -y
```
# Install GO 1.19.1
```
cd $HOME
ver="1.19.1"
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
go version
```
  
# Build celestia 
```
cd $HOME
rm -rf celestia-node
git clone https://github.com/celestiaorg/celestia-node.git
cd celestia-node/
git checkout tags/v0.5.0-rc5
make install
make cel-key

celestia version
```
  
# Light Node Start :
- init 
```
celestia light init
```
- add key
```
./cel-key add <KEY-NAME> --keyring-backend test --node.type ligh
  Or recover wallet old
./cel-key add <KEY-NAME> --keyring-backend test  --recover --node.type light
  example
./cel-key add w248light --keyring-backend test  --recover --node.type light
```
- add bootstrap peers
```
BootstrapPeers="[\"/dns4/andromeda.celestia-devops.dev/tcp/2121/p2p/12D3KooWKvPXtV1yaQ6e3BRNUHa5Phh8daBwBi3KkGaSSkUPys6D\", \"/dns4/libra.celestia-devops.dev/tcp/2121/p2p/12D3KooWK5aDotDcLsabBmWDazehQLMsDkRyARm1k7f1zGAXqbt4\", \"/dns4/norma.celestia-devops.dev/tcp/2121/p2p/12D3KooWHYczJDVNfYVkLcNHPTDKCeiVvRhg8Q9JU3bE3m9eEVyY\"]"

sed -i -e "s|BootstrapPeers *=.*|BootstrapPeers = $BootstrapPeers|" $HOME/.celestia-light/config.toml
```
 - start Lightnode with keyname ( edit file config "/root/.celestia-light-arabica-2/config.toml" with option )
 ```
 celestia light start --keyring.accname <key_name> --core.ip <ip-address> --core.grpc.port <port> --gateway --gateway.addr <ip-address> --gateway.port <port>
 example :
 celestia light start --keyring.accname w248light --core.ip https://limani.celestia-devops.dev --core.grpc.port 4090 --gateway --gateway.addr 161.97.149.123 --gateway.port 24659
 ```
 # Create and run service
 ```
sudo tee /etc/systemd/system/celestia-lightd.service > /dev/null <<EOF
[Unit]
Description=celestia-lightd Light Node
After=network-online.target

[Service]
User=$USER
ExecStart=/usr/local/bin/celestia light start --core.ip https://limani.celestia-devops.dev --core.grpc.port 4090
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
systemctl enable celestia-lightd
systemctl restart celestia-lightd
```
```
systemctl status celestia-lightd

journalctl -u celestia-lightd.service -f -o cat
```

# delete node
```
sudo systemctl stop celestia-lightd && sudo systemctl disable celestia-lightd
rm -rf /etc/systemd/system/celestia-lightd.service 
rm -rf /usr/local/bin/celestia
rm -rf /root/celestia-node/
rm -rf /root/.celestia-light-arabica-2/
```
