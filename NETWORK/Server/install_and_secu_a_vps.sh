#!/bin/bash
echo "IP DE VOTRE SERVEUR :"
read ip
echo "E-mail"
read email
echo "Quel port SSH voulez-vous ?"
read sshport
apt-get update ; apt-get upgrade -y
apt-get install php5 apache2 curl php5-curl php5-gd htop fail2ban mysql-server sendmail -y
apt-get install unzip php5-mysql -y
cd /var/www/
rm index.html
echo "<?php phpinfo(); ?>" > index.php
cd /tmp
wget http://scripts.hexicans.eu/scriptsfiles/phpMyAdmin-4.4.13.1-all-languages.zip
unzip phpMyAdmin-4.4.13.1-all-languages.zip
mv /tmp/phpMyAdmin-4.4.13.1-all-languages /var/www/
cd /var/www/
mv phpMyAdmin-4.4.13.1-all-languages phpmyadmin
cd /tmp/
rm phpMyAdmin-4.4.13.1-all-languages.zip
wget http://scripts.hexicans.eu/scriptsfiles/ioncube_loaders_lin_x86-64.tar.gz
tar xfz ioncube_loaders_lin_x86-64.tar.gz
mv ioncube /usr/local/
rm ioncube_loaders_lin_x86-64.tar.gz
echo "zend_extension = /usr/local/ioncube/ioncube_loader_lin_5.4.so" >> /etc/php5/apache2/php.ini
echo "zend_extension = /usr/local/ioncube/ioncube_loader_lin_5.4.so" >> /etc/php5/cli/php.ini
service apache2 restart
apt-get install libapache2-mod-php5 php5 php5-common php5-curl php5-dev php5-gd php5-idn php-pear php5-imagick php5-imap php5-json php5-mcrypt php5-memcache php5-mhash php5-ming php5-mysql php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl -y
apt-get install php-apc -y
service apache2 restart
VERT="\\033[1;32m" 
NORMAL="\\033[0;39m" 
ROSE="\\033[1;35m" 
apt-get install htop iftop apachetop nano -y
cd /etc/php5/apache2/
rm php.ini
wget http://scripts.hexicans.eu/scriptsfiles/php5/apache2/php.ini
chmod 644 php.ini
cd /etc/php5/cli/
rm php.ini
wget http://scripts.hexicans.eu/scriptsfiles/php5/cli/php.ini
chmod 644 php.ini
cd /etc/fail2ban/
rm jail.conf
echo "[DEFAULT]

# "ignoreip" can be an IP address, a CIDR mask or a DNS host. Fail2ban will not
# ban a host which matches an address in this list. Several addresses can be
# defined using space separator.
ignoreip = 127.0.0.1/8 

# External command that will take an tagged arguments to ignore, e.g. <ip>,
# and return true if the IP is to be ignored. False otherwise.
#
# ignorecommand = /path/to/command <ip>
ignorecommand =

# "bantime" is the number of seconds that a host is banned.
bantime  = 1800

# A host is banned if it has generated "maxretry" during the last "findtime"
# seconds.
findtime  = 900

# "maxretry" is the number of failures before a host get banned.
maxretry = 3

# "backend" specifies the backend used to get files modification.
# Available options are "pyinotify", "gamin", "polling" and "auto".
# This option can be overridden in each jail as well.
#
# pyinotify: requires pyinotify (a file alteration monitor) to be installed.
#              If pyinotify is not installed, Fail2ban will use auto.
# gamin:     requires Gamin (a file alteration monitor) to be installed.
#              If Gamin is not installed, Fail2ban will use auto.
# polling:   uses a polling algorithm which does not require external libraries.
# auto:      will try to use the following backends, in order:
#              pyinotify, gamin, polling.
backend = auto

# "usedns" specifies if jails should trust hostnames in logs,
#   warn when DNS lookups are performed, or ignore all hostnames in logs
#
# yes:   if a hostname is encountered, a DNS lookup will be performed.
# warn:  if a hostname is encountered, a DNS lookup will be performed,
#        but it will be logged as a warning.
# no:    if a hostname is encountered, will not be used for banning,
#        but it will be logged as info.
usedns = warn


# This jail corresponds to the standard configuration in Fail2ban.
# The mail-whois action send a notification e-mail with a whois request
# in the body.

[pam-generic]

enabled = true
filter  = pam-generic
action  = iptables-allports[name=pam,protocol=all]
logpath = /var/log/secure


[ssh-iptables]

enabled  = true
filter   = sshd
action   = iptables[name=SSH, port=ssh, protocol=tcp]
           sendmail-whois[name=SSH, dest=$email, sender=$email, sendername=""Fail2Ban""]
logpath  = /var/log/secure


[ssh-ddos]

enabled  = true
filter   = sshd-ddos
action   = iptables[name=SSHDDOS, port=ssh, protocol=tcp]
logpath  = /var/log/secure

" > /etc/fail2ban/jail.conf
chmod 644 jail.conf
service fail2ban stop
service fail2ban start
cd /etc/ssh/
rm sshd_config
echo "# Package generated configuration file
# See the sshd_config(5) manpage for details

# What ports, IPs and protocols we listen for
Port $sshport
# Use these options to restrict which interfaces/protocols sshd will bind to
#ListenAddress ::
#ListenAddress 0.0.0.0
Protocol 2
# HostKeys for protocol version 2
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_dsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
#Privilege Separation is turned on for security
UsePrivilegeSeparation yes

# Lifetime and size of ephemeral version 1 server key
KeyRegenerationInterval 3600
ServerKeyBits 768

# Logging
SyslogFacility AUTH
LogLevel INFO

# Authentication:
LoginGraceTime 120
PermitRootLogin yes
StrictModes yes

RSAAuthentication yes
PubkeyAuthentication yes
#AuthorizedKeysFile	%h/.ssh/authorized_keys

# Don't read the user's ~/.rhosts and ~/.shosts files
IgnoreRhosts yes
# For this to work you will also need host keys in /etc/ssh_known_hosts
RhostsRSAAuthentication no
# similar for protocol version 2
HostbasedAuthentication no
# Uncomment if you don't trust ~/.ssh/known_hosts for RhostsRSAAuthentication
#IgnoreUserKnownHosts yes

# To enable empty passwords, change to yes (NOT RECOMMENDED)
PermitEmptyPasswords no

# Change to yes to enable challenge-response passwords (beware issues with
# some PAM modules and threads)
ChallengeResponseAuthentication no

# Change to no to disable tunnelled clear text passwords
#PasswordAuthentication yes

# Kerberos options
#KerberosAuthentication no
#KerberosGetAFSToken no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes

# GSSAPI options
#GSSAPIAuthentication no
#GSSAPICleanupCredentials yes

X11Forwarding yes
X11DisplayOffset 10
PrintMotd no
PrintLastLog yes
TCPKeepAlive yes
#UseLogin no

#MaxStartups 10:30:60
#Banner /etc/issue.net

# Allow client to pass locale environment variables
AcceptEnv LANG LC_*

Subsystem sftp /usr/lib/openssh/sftp-server

# Set this to 'yes' to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the ChallengeResponseAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via ChallengeResponseAuthentication may bypass
# the setting of "PermitRootLogin without-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and ChallengeResponseAuthentication to 'no'.
UsePAM yes
" > sshd_config
chmod 644 sshd_config
service ssh restart
service apache2 restart
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
echo -e "$CYAN" "  " ""$ROSE"" "                Port SSH / SFTP : $sshport"
echo -e "$CYAN" "##" ""$ROSE"" "                                                                   "$CYAN"" "##"
echo -e "$CYAN" "  " ""$ROSE"" "                L'email pour FAIL2BAN est $email"
echo -e "$CYAN" "##" ""$ROSE"" "                                                                   "$CYAN"" "##"
echo -e "$CYAN" "  " ""$ROSE"" "                Votre serveur est pret a l'utilisation."
echo -e "$CYAN" "##########################################################################"
echo -e "$NORMAL"



exit 0

