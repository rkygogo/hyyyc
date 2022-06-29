#!/bin/sh
mkdir -p /etc/hysteria
hysteria_port="14000"
hysteria_obfs="ycycxz"
hysteria_passwd="ycycxz"

killall hysteria
version=`wget -qO- -t1 -T2 --no-check-certificate "https://api.github.com/repos/HyNetwork/hysteria/releases/latest" | grep "tag_name" | head -n 1 | awk -F ":" '{print $2}' | sed 's/\"//g;s/,//g;s/ //g'`
	echo -e "The Latest hysteria version:"`echo "${version}"`"\nDownload..."
    get_arch=`arch`
    if [ $get_arch = "x86_64" ];then
        wget -N https://github.com/rkygogo/yy/blob/main/hysteria-tun-linux-amd64 -O /usr/bin/hysteria
	
    else
        wget -N --no-check-certificate https://github.com/HyNetwork/hysteria/releases/download/${version}/hysteria-linux-arm64 -O /usr/bin/hysteria
fi
chmod +x /usr/bin/hysteria

openssl ecparam -genkey -name prime256v1 -out /etc/hysteria/ca.key
openssl req -new -x509 -days 36500 -key /etc/hysteria/ca.key -out /etc/hysteria/ca.crt -subj "/CN=www.baidu.com"

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
