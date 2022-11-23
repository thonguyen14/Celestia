Arbica
# Install go 1.19.1
# install celestia-node
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
# add key
```
./cel-key add <key_name> --keyring-backend test --node.type bridge
or recover wallet old:
./cel-key add <key_name> --keyring-backend test --recover --node.type bridge

example : ./cel-key add w248bridge --keyring-backend test --recover --node.type bridge
```
# Initialize bridge node
- init
```
celestia bridge init --core.ip <ip-address> --core.rpc.port <port>

example : celestia bridge init --core.ip https://limani.celestia-devops.dev --core.rpc.port 7090
```
- start
```
celestia bridge start --core.ip <ip-address> --core.grpc.port <port>

example: celestia bridge start  --keyring.accname w248bridge --core.ip https://limani.celestia-devops.dev --core.grpc.port 7090 --gateway --gateway.addr 161.97.149.123 --gateway.port 23659
```
# Create bridge service
```
sudo tee /etc/systemd/system/celestia-bridge.service > /dev/null <<EOF
[Unit]
Description=celestia-bridge Cosmos daemon
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=/usr/local/bin/celestia bridge start --core.ip https://limani.celestia-devops.dev --core.grpc.port 7090
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
```
# Register and start bridge service
```
sudo systemctl daemon-reload
sudo systemctl enable celestia-bridge
sudo systemctl restart celestia-bridge.service

sudo systemctl status celestia-bridge.service

journalctl -u celestia-bridge.service -f -o cat
```
# delete node
```
sudo systemctl stop celestia-bridge.service && sudo systemctl disable celestia-bridge.service
rm -rf /etc/systemd/system/celestia-bridge.service 
rm -rf /usr/local/bin/celestia 
rm -rf /root/celestia-node/
rm -rf /root/.celestia-bridge-arabica-2/
