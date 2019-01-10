#!/bin/bash
wget http://a.free-heberg.eu/edit/workspace/scripts/htop-1.0.1.tar.gz
yum install ncurses-devel gcc make
tar xvzf htop-1.0.1.tar.gz
cd htop-1.0.1
./configure --enable-openvz
make
make install
rm /usr/bin/htop
mv /usr/local/bin/htop /usr/bin/
