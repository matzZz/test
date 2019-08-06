#!/bin/bash
#  
# homebridger v0.1 (2019)
#
# following Smartapfel Manual by sschuste
#
# provided by Sebbo187

echo "Vorbereitungen werden getroffen.."
echo
echo "Avahi wird installiert.."
sudo apt-get install libavahi-compat-libdnssd-dev --yes
echo
echo "Git wird installiert.."
sudo apt-get install git
echo
echo "Node wird installiert.."
wget https://nodejs.org/dist/v10.16.0/node-v10.16.0-linux-armv7l.tar.gz
echo
tar xf node-v10.16.0-linux-armv7l.tar.gz
echo
sudo cp -R node-v10.16.0-linux-armv7l/* /usr/local/
echo
echo "Node-Versionsmanager wird installiert.."
echo
sudo npm install -g n
echo
sudo n lts
echo
echo "Homebridge User wird eingerichtet.." 
echo
sudo useradd -m -c "Homebridge Service" -s /bin/bash -G audio,bluetooth,dialout,gpio,systemd-journal,video homebridge
echo
echo 'homebridge ALL=(ALL) SETENV:NOPASSWD: ALL' >> /etc/sudoers.d/homebridge
echo 
sudo chmod 640 /etc/sudoers.d/homebridge
echo
echo "Homebridge wird installiert.."
echo
sudo npm install -g --unsafe-perm homebridge
sudo mkdir -p /var/homebridge
echo
echo "config.json wird erstellt.."
echo
echo -e '{ \n"bridge": { \n"name": "Homebridge", \n"username": "CC:22:3D:E3:CE:30", \n"port": 51826, \n"pin": "031-45-154" \n}, \n"description": "Home Smart Home", \n"platforms": [], \n"accessories": [] \n}' >> /var/homebridge/config.json
sudo chown -R homebridge:homebridge /var/homebridge
echo
echo "Systemd-Startskript wird erstellt.."
echo
echo -e "[Unit]\nDescription=Node.js HomeKit Server\nAfter=syslog.target network-online.target" >> /etc/systemd/system/homebridge.service
echo "" >> /etc/systemd/system/homebridge.service
echo -e  "[Service]\nType=simple\nUser=homebridge\nEnvironmentFile=/etc/default/homebridge" >> /etc/systemd/system/homebridge.service
echo 'ExecStart=/usr/local/bin/homebridge $HOMEBRIDGE_OPTS' >> /etc/systemd/system/homebridge.service
echo -e "Restart=on-failure\nRestartSec=10\nKillMode=process" >> /etc/systemd/system/homebridge.service
echo "" >> /etc/systemd/system/homebridge.service
echo -e "[Install]\nWantedBy=multi-user.target" >> /etc/systemd/system/homebridge.service
echo 'HOMEBRIDGE_OPTS=-I -U /var/homebridge' >> /etc/default/homebridge
echo
echo "Systemd updaten.."
echo 
sudo systemctl daemon-reload
sudo systemctl enable homebridge
echo
echo "Die Homebridge wird gestartet.."
echo
sudo systemctl restart homebridge; sudo journalctl -fau homebridge

