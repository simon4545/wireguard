wget https://github.com/net-byte/vtun/releases/download/v1.7.0/vtun-linux-amd64
chmod +x vtun-linux-amd64
apt install net-tools
curl -sL https://mirrors.ustc.edu.cn/nodesource/deb/setup_16.x | bash -
apt-get install -y nodejs
npm i -g pm2
pm2 start ./vtun-linux-amd64 -- -S -l :16000 -obfs -p ws -path /wplogin -c 10.0.0.1/24 -k asdfasdf110 -v


echo net.ipv4.ip_forward = 1 >> /etc/sysctl.conf
sysctl -p
echo "1"> /proc/sys/net/ipv4/ip_forward

eth=$(ls /sys/class/net | awk '/^e/{print}')

iptables -t nat -A POSTROUTING -o $eth -j MASQUERADE
iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE
iptables -A INPUT -i $eth -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -i tun0 -m state --state RELATED,ESTABLISHED -j ACCEPT

iptables -A FORWARD -j ACCEPT
# ./vtun-linux-amd64 -s 18.176.51.105:16000 -c 10.0.0.2/24 -k asdfasdf110 -g
