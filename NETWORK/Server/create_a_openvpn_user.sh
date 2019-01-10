#!/bin/bash
echo "Nom du certificat: (ex: client4)"
read cn
echo "IP du serveur"
read ip
cd /etc/openvpn/easy-rsa
source vars
./build-key-pass $cn
mkdir /etc/openvpn/clientconf/$cn/
cp /etc/openvpn/ca.crt /etc/openvpn/ta.key keys/$cn.crt keys/$cn.key /etc/openvpn/clientconf/$cn/
cd /etc/openvpn/clientconf/$cn/
echo "
# Client
client
dev tun
proto tcp-client
remote $ipserver 443
resolv-retry infinite
cipher AES-256-CBC

# Cles
ca ca.crt
cert $cn.crt
key $cn.key
tls-auth ta.key 1
key-direction 1

# Secu
nobind
persist-key
persist-tun
comp-lzo
verb 3" > $cn.conf
cp $cn.conf $cn.ovpn
cd /
cd /etc/openvpn/clientconf/

zip -r $cn.zip $cn 

echo "Adresse mail du client : (ex test@gmail.fr)"
read email
echo "Bonjour, Trouvez ci joint votre ZIP pour le VPN" | mutt -s "Votre VPN est livre!" -a $cn.zip -- $email
exit

exit 0
