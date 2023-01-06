#!/bin/bash

wireguard_remove(){
    sudo wg-quick down wg0
    sudo apt-get remove -y wireguard
    sudo rm -rf /etc/wireguard
}

wireguard_install(){
    wireguard_remove
    version=$(cat /etc/os-release | awk -F '[".]' '$1=="VERSION="{print $2}')
    if [ $version == 18 ]; then
        sudo apt-get update -y
        sudo apt-get install -y software-properties-common
        sudo apt-get install -y openresolv
    #else
     #   sudo apt-get update -y
      #  sudo apt-get install -y software-properties-common
    fi
    #sudo add-apt-repository -y ppa:wireguard/wireguard
    sudo apt-get update -y
    sudo apt-get install -y wireguard curl
    sudo apt-get install -y resolvconf
    
    sudo echo net.ipv4.ip_forward = 1 >> /etc/sysctl.conf
    sysctl -p
    echo "1"> /proc/sys/net/ipv4/ip_forward
    
    mkdir /etc/wireguard
    cd /etc/wireguard
    
    s1=yOPRDNtT1+IYQ9D9WRlapsbEyHAsDzKCQyK+3kgrK3Y=
    s2=oULO9FbVyf2gJizVBuYU17vLjG+rczciLkG1dpmCvlI=
    c1=iH49btV3gCbqS0sIgRXa/WUz41axK5W888WC9mudY0s=
    c2=8nXYw0xvWIYkslQzSbAKjU6+ZNYbmm03RWGvnPDd3xQ=
    serverip=$(curl ipv4.icanhazip.com)
    port=16000
    eth=$(ls /sys/class/net | awk '/^e/{print}')
    interfaceip=$(ifconfig $eth | awk -F ' *|:' '/inet /{print $3}')

sudo cat > /etc/wireguard/wg0.conf <<-EOF
[Interface]
PrivateKey = $s1
Address = 10.0.0.1/24 
PostUp   = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o $eth -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o $eth -j MASQUERADE
ListenPort = $port
DNS = 8.8.8.8
MTU = 1420

[Peer]
PublicKey = $c2
AllowedIPs = 10.0.0.2/32
EOF


sudo cat > /etc/wireguard/client.conf <<-EOF
[Interface]
PrivateKey = $c1
Address = 10.0.0.2/24 
DNS = 8.8.8.8
MTU = 1420

[Peer]
PublicKey = $s2
Endpoint = $serverip:$port
AllowedIPs = 0.0.0.0/0, ::0/0
PersistentKeepalive = 25
EOF

    

sudo cat > /etc/init.d/wgstart <<-EOF
#! /bin/bash
### BEGIN INIT INFO
# Provides:		wgstart
# Required-Start:	$remote_fs $syslog
# Required-Stop:    $remote_fs $syslog
# Default-Start:	2 3 4 5
# Default-Stop:		0 1 6
# Short-Description:	wgstart
### END INIT INFO
sudo wg-quick up wg0
EOF

    sudo chmod +x /etc/init.d/wgstart
    cd /etc/init.d
    if [ $version == 14 ]
    then
        sudo update-rc.d wgstart defaults 90
    else
        sudo update-rc.d wgstart defaults
    fi
    
    sudo wg-quick up wg0
    
    port_forward

    content=$(cat /etc/wireguard/client.conf)
    echo -e "\033[43;42m电脑端请下载/etc/wireguard/client.conf\033[0m"
    echo "${content}"
}

port_forward(){
	# 设置端口转发
	sudo iptables -t nat -I PREROUTING -d $interfaceip -p tcp -m multiport ! --dports 22,1080,8080,16000 -j DNAT --to-destination 10.0.0.2
	sudo iptables -t nat -I PREROUTING -d $interfaceip -p udp -m multiport ! --dports 22,1080,8080,16000 -j DNAT --to-destination 10.0.0.2
	sudo iptables -t nat -I POSTROUTING -s 10.0.0.2 -j SNAT --to-source $interfaceip
	sudo service iptables save
}

wireguard_install
