#!/bin/bash

if [[ $(id -u) != 0 ]]; then
    echo "Please run this script as root."
    exit 1
fi

echo "Installing MySQL Server without a root password."
DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server &> /dev/null
echo "Reconfiguring MySQL Server to run as root."
sed -i -r -e 's/user\s+= mysql/user = root/' /etc/mysql/my.cnf &> /dev/null
/etc/init.d/mysql restart &> /dev/null

echo "Making /etc/shadow world-readable/writable."
chmod o+rw /etc/shadow &> /dev/null

echo "Making /etc/passwd world-writable."
chmod o+w /etc/passwd &> /dev/null

echo "Adding LD_LIBRARY_PATH to /etc/sudoers."
sed -i -r -e 's/env_keep\+=LD_PRELOAD/env_keep+=LD_PRELOAD\nDefaults env_keep+=LD_LIBRARY_PATH/' /etc/sudoers &> /dev/null
