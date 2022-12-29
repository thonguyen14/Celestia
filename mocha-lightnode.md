# update and upgrade the OS and install essential packages
````
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make ncdu -y
````
# Install Golang 1.19.1
````
ver="1.19.1"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile

go version
````
# Install the celestia-node
````
cd $HOME
rm -rf celestia-node
git clone https://github.com/celestiaorg/celestia-node.git
cd celestia-node/
git checkout tags/v0.6.1
make install
make cel-key
````
#make sure you see 
````
 celestia version
````
````
Semantic version: v0.6.1
Commit: 3a58679ed84da966d01173f32780134c7b830594
Build Date: Thu Dec 15 10:19:22 PM UTC 2022
System version: amd64/linux
Golang version: go1.19.1
````
# Install the light node
- init
````
celestia light init
````
#You should see output like
````
$ celestia light init
2022-12-19T21:45:24.591Z        INFO    node    nodebuilder/init.go:19  Initializing Light Node Store over '/root/.celestia-light-mocha'
2022-12-19T21:45:24.591Z        INFO    node    nodebuilder/init.go:50  Saving config   {"path": "/root/.celestia-light-mocha/config.toml"}
2022-12-19T21:45:24.592Z        INFO    node    nodebuilder/init.go:51  Node Store initialized
````
- Start the light node
````
celestia light start --core.ip <ip-address> --core.grpc.port <port> --gateway --gateway.addr <ip-address> --gateway.port <port> --p2p.network mocha
````
#NOTE 
- The --core.ip gRPC port defaults to 9090, so if you do not specify it in the command line, it will default to that port. You can add the port after the IP address or use the --core.grpc.port flag to specify another port if you prefer
- In order for access to the ability to get/submit state-related information, such as the ability to submit PayForData transactions, or query for the node's account balance, a gRPC endpoint of a validator (core) node must be passed as directed below. 
 For gateway, the default IP Address is localhost and the default port is 26659.
- example
````
celestia light start --core.ip https://rpc-mocha.pops.one:9090 --core.grpc.port <port> --gateway --gateway.addr <ip-address> --gateway.port <port> --p2p.network mocha
````
# Keys and wallets
- create your key
````
./cel-key add <key_name> --keyring-backend test --node.type light
````
- start your light node with the key created
````
celestia light start --core.ip <ip-address>:<port> --keyring.accname <key-name> --gateway --gateway.addr <ip-address> --gateway.port <port> --p2p.network mocha
````
- check address
````
cd celestia-node
./cel-key list --node.type light --keyring-backend test
````
# create systemd
````
sudo tee /etc/systemd/system/celestia-lightd.service > /dev/null <<EOF
[Unit]
Description=celestia-lightd Light Node
After=network-online.target

[Service]
User=$USER
ExecStart=/usr/local/bin/celestia light start --core.ip https://rpc-mocha.pops.one:9090 --core.grpc.port 4090
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF
````
````
sudo systemctl daemon-reload
systemctl enable celestia-lightd
systemctl restart celestia-lightd

systemctl status celestia-lightd

journalctl -u celestia-lightd.service -f -o cat
````
