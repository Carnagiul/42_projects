#!/bin/bash
echo "IP DU SERVEUR : "
read ipserver
apt-get install openvpn openssl zip sendmail sendmail-bin unzip mutt -y
mkdir /etc/openvpn/easy-rsa/
cp -r /usr/share/doc/openvpn/examples/easy-rsa/2.0/* /etc/openvpn/easy-rsa/
cd /etc/openvpn/easy-rsa/
source vars
./clean-all
./build-dh
./pkitool --initca
./pkitool --server server
openvpn --genkey --secret keys/ta.key
cp keys/ca.crt keys/ta.key keys/server.crt keys/server.key keys/dh1024.pem /etc/openvpn/
mkdir /etc/openvpn/jail && mkdir /etc/openvpn/clientconf
cd /etc/openvpn/
echo "#Serveur TCP/443
mode server
proto tcp
port 443
dev tun

#Cles certificats
ca ca.crt
cert server.crt
key server.key
dh dh1024.pem
tls-auth ta.key 1
key-direction 0
cipher AES-256-CBC

#Reseau
server 10.8.0.0 255.255.255.0
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 10 120

#Secu
user nobody
group nogroup
chroot /etc/openvpn/jail
persist-key
persist-tun
comp-lzo

# Log
verb 3
mute 20
status openvpn-status.log
log-append /var/log/openvpn.log" > server.conf
cd /etc/openvpn
sh -c 'echo 1 > /proc/sys/net/ipv4/ip_forward'
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o venet0 -j MASQUERADE
service openvpn restart
echo "Nom du certificat: (ex: client4)"
read cn

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

