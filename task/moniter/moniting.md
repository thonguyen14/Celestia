# Enable tendermint metrics
#To enable the export of the Tendermint metrics, you need to set the flag for Prometheus to true in the [instrumentation] section inside of your config.toml file:
```
[instrumentation]
prometheus = true
prometheus_listen_addr = ":26660"
```
# Prometheus Installation and Configuration
- Verify available versions
```
sudo apt-cache policy prometheus
```
- Create Prometheus user
```
sudo useradd -M -r -s /bin/false prometheus
```
- Create Prometheus directories
```
sudo mkdir /etc/prometheus /var/lib/prometheus
```
- Dowload binaries
```
wget https://github.com/prometheus/prometheus/releases/download/v2.43.0/prometheus-2.43.0.linux-amd64.tar.gz
```
- Extract and Install
```
tar xzf prometheus-2.43.0.linux-amd64.tar.gz  
sudo cp prometheus-2.43.0.linux-amd64/{prometheus,promtool} /usr/local/bin/  
sudo chown prometheus:prometheus /usr/local/bin/{prometheus,promtool}  
sudo cp -r prometheus-2.43.0.linux-amd64/{consoles,console_libraries} /etc/prometheus/
```
- Setup Prometheus configuration
```
sudo cp prometheus-2.43.0.linux-amd64/prometheus.yml /etc/prometheus/prometheus.yml  
sudo nano /etc/prometheus/prometheus.yml
# fill 
    static_configs:  
    - targets: ['localhost:9091']  
  
  - job_name: 'Celestia-light'  
    static_configs:  
      - targets: ['localhost:26660']  
        labels:  
          group: 'light'  
  
  - job_name: node  
    static_configs:  
      - targets: ['localhost:9100']  
```
- Set the user and group ownership on the configuration file
```
sudo chown -R prometheus:prometheus /etc/prometheus  
sudo chown prometheus:prometheus /var/lib/prometheus
```
- Create a systemd file for Prometheus - in this scenario Prometheus uses 9091 as listen port
```
sudo tee /etc/systemd/system/prometheus.service > /dev/null <<EOF
[Unit]  
Description=Prometheus Time Series Collection and Processing Server  
Wants=network-online.target  
After=network-online.target  
  
[Service]  
User=prometheus  
Group=prometheus  
Type=simple  
ExecStart=/usr/local/bin/prometheus \  
    --config.file /etc/prometheus/prometheus.yml \  
    --storage.tsdb.path /var/lib/prometheus/ \  
    --web.console.templates=/etc/prometheus/consoles \  
    --web.console.libraries=/etc/prometheus/console_libraries\  
    --web.listen-address="0.0.0.0:9091"  
  
[Install]  
WantedBy=multi-user.target
EOF

sudo systemctl enable prometheus
sudo systemctl start prometheus
sudo systemctl status prometheus
```
# Node Exporter Installation and Configuration
```
wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz
tar xvf node_exporter-1.5.0.linux-amd64.tar.gz
rm node_exporter-1.5.0.linux-amd64.tar.gz
sudo mv node_exporter-1.5.0.linux-amd64 node_exporter
chmod +x $HOME/node_exporter/node_exporter
sudo mv $HOME/node_exporter/node_exporter /usr/bin
rm -Rvf $HOME/node_exporter/  
```
-  Create systemd file
```
sudo tee /etc/systemd/system/exporterd.service > /dev/null <<EOF
[Unit]
Description=node_exporter
After=network-online.target
[Service]
User=$USER
ExecStart=/usr/bin/node_exporter
Restart=always
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable exporterd
sudo systemctl start exporterd

sudo systemctl status exporterd
```
# Install and Configure Grafana
- Install necessary packages and Grafana
```
sudo apt install software-properties-common  
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -  
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"  
sudo apt update  
sudo apt-cache policy grafana  
sudo apt install grafana
```
- Install Grafana pie chart plugin
```
sudo grafana-cli plugins install grafana-piechart-panel
```
- Start Grafana server
```
sudo systemctl start grafana-server
```
- Enable Grafana server at startup
```
sudo systemctl enable grafana-server
```
- Check the status of Grafana server
```
sudo systemctl status grafana-server
```
#go to Grafana as http://IP:3000
In Grafana first add Prometheus as a new data source under Configuration. Define "Prometheus" as name for the data source and as URL enter "http://localhost:9091" if you are running all components (Grafana and Prometheus on the same instance). Otherwise you will have to enter the IP of the machine where Prometheus is running instead of localhost.
