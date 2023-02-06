wget https://github.com/XTLS/Xray-install/raw/main/install-release.sh
bash install-release.sh
cat > /usr/local/etc/xray/config.json <<-EOF{
    "log": {
        "loglevel": "debug"
    },
    "dns": {
        "servers": [
            "1.1.1.1",
            "8.8.8.8",
            "8.8.4.4"
        ]
    },
    "inbounds": [
        {
            "listen": "0.0.0.0",
            "port": 10086,
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "c71c5890-56dd-4f32-bb99-3070ec2f20fa"
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "tcp"
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom",
            "settings": {
                "domainStrategy": "UseIP"
            },
            "tag": "free"
        }
    ],
    "routing": {
        "rules": []
    }
}
EOF
