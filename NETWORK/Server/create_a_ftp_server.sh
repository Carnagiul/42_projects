#!/bin/bash
clear
echo ""
echo ""
echo "Ce script est a executer en root"
echo ""
echo ""
apt-get install pure-ftpd pure-ftpd-common
groupadd ftpgroup
useradd -g ftpgroup -d /dev/null -s /etc ftpuser
echo "no" > /etc/pure-ftpd/conf/PAMAuthentication
echo "yes" > /etc/pure-ftpd/conf/DontResolve
cd /etc/pure-ftpd/auth/
sudo ln -s ../conf/PureDB 50puredb
echo "30110 30210" > /etc/pure-ftpd/conf/PassivePortRange 
iptables -A INPUT -p tcp --match multiport --dports 30110:30210 -j ACCEPT
echo "Utilisateur FTP ?"
read userftp
echo "Repertoire a assigner a l'utilisateur ?(Par exemple /home/test/) "
read dossier
chown -R ftpuser:ftpgroup $dossier
pure-pw useradd $userftp -u ftpuser -g ftpgroup -d $dossier
pure-pw mkdb
service pure-ftpd restart
VERT="\\033[1;32m" 
NORMAL="\\033[0;39m" 
ROUGE="\\033[1;31m" 
ROSE="\\033[1;35m" 
BLEU="\\033[1;34m" 
BLANC="\\033[0;02m" 
BLANCLAIR="\\033[1;08m" 
JAUNE="\\033[1;33m" 
CYAN="\\033[1;36m"
VERT="\\033[1;32m"
NORMAL="\\033[0;39m"
ROUGE="\\033[1;31m"
ROSE="\\033[1;35m"
BLEU="\\033[1;34m"
BLANC="\\033[0;02m"
BLANCLAIR="\\033[1;08m"
JAUNE="\\033[1;33m"
CYAN="\\033[1;36m"

echo ""
echo -e "$CYAN" "##########################################################################"
echo -e "$CYAN" "  " ""$ROSE"" "        L'utilisateur creer est $userftp"
echo -e "$CYAN" "##" ""$ROSE"" "                                                                   "$CYAN"" "##"
echo -e "$CYAN" "  " ""$ROSE"" "        Le/Les dossier(s) ou il a acces est/sont $dossier"
echo -e "$CYAN" "##" ""$ROSE"" "                                                                   "$CYAN"" "##"
echo -e "$CYAN" "  " ""$ROSE"" "        Merci d''avoir utiliser ce script."
echo -e "$CYAN" "##########################################################################"
echo -e "$NORMAL"


exit 0


