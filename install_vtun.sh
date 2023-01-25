wget https://github.com/net-byte/vtun/releases/download/v1.7.0/vtun-linux-amd64
chmod +x vtun-linux-amd64
apt install net-tools
pm2 start ./vtun-linux-amd64 -- -S -l :16000 -p ws -path /wplogin -c 10.0.0.1/24 -k asdfasdf110 -v


vi /etc/sysctl.conf
net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding=1
sysctl -p /etc/sysctl.conf

iptables -t nat -A POSTROUTING -o ens5 -j MASQUERADE
iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE
iptables -A INPUT -i ens5 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -i tun0 -m state --state RELATED,ESTABLISHED -j ACCEPT

iptables -A FORWARD -j ACCEPT



wget https://github.com/net-byte/vtun/releases/download/v1.7.0/vtun-linux-amd64
pm2 start ./vtun-linux-amd64 -- -s 18.176.51.105:16000 -c 10.0.0.2/24 -k asdfasdf110 -g


./vtun-linux-amd64 -s 18.176.51.105:16000 -c 10.0.0.2/24 -k asdfasdf110 -g
