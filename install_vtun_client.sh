apt install net-tools
wget https://filobj.oss-cn-hangzhou.aliyuncs.com/vtun-linux-amd64
chmod +x vtun-linux-amd64
curl -sL https://mirrors.ustc.edu.cn/nodesource/deb/setup_16.x | bash -
apt-get install -y nodejs
npm i -g pm2
pm2 start ./vtun-linux-amd64 -- -s 18.176.51.105:16000 -p ws -path /wplogin -c 10.0.0.2/24 -k asdfasdf110 -g
