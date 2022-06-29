#!/bin/sh

hysteria_port="14000"
hysteria_obfs="ycycxz"
hysteria_passwd="ycycxz"

killall hysteria
wget -qO /usr/local/bin/hysteria https://cdn.jsdelivr.net/gh/none-blue/hysteria_amd64@main/hysteria
wget -qO /usr/local/bin/xray https://cdn.jsdelivr.net/gh/none-blue/xray_amd64@main/xray
chmod +x /usr/local/bin/{hysteria,xray}

mkdir -p /etc/hysteria
xray tls cert --ca \
--domain="cdn" \
--name="cdn" \
--org="cdn" \
--expire=8760000h \
--file=/etc/hysteria/ \
--json=false

cat << EOF > /etc/hysteria/serve.json
{
"listen": "[::]:$hysteria_port",
"cert": "/etc/hysteria/_cert.pem",
"obfs": "hysteria_obfs",
"auth": {
      "mode": "passsword",
      "config": ["hysteria_passwd"]
},
"ipv6_only": true,
"resolver": "2001:4860:4860::8888"
}

EOF

nohup hysteria -c /etc/hysteria/serve.json server > /dev/null 2>&1 &

echo "hysteria://`curl -6skL https://ifconfig.co`:$hysteria_port?protocol=udp&auth=$hysteria_passwd&insecure=0&obfsParam=$hysteria_obfs#hy"
