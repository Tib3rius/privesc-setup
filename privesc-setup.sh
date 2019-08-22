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

echo "Changing OpenVPN credentials."
sed -i -r -e 's/user/root/' /etc/openvpn/auth.txt &> /dev/null
sed -i -r -e 's/password321/password123/' /etc/openvpn/auth.txt &> /dev/null

echo "Creating weak root SSH keys."
mkdir /root/.ssh &> /dev/null
mkdir /.ssh &> /dev/null
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDcgh/pZzNx2bfwxn35AANJir0V8p/CPSYlpS17IkdYdnf8Y2aAtMfcWi/ZKzxC4Z++8PgJDV/g3Q+qdonZYmspI/xDLEnti1FOTQmhNIZZN5SkTGWnihKZPFic7QsNyx7PA2EFmfSSWO0a72n52aYpuTjRbhJaVO9TUtwQdGvpGBYyBCg4eHFQV10W1iuSdLgaIvlMkfpu3nvGggQKdFz/yy5nJbOBHNuj5O8N7ArdmEE3scN5X0bkmuOdWsOpKOHKxQA2ZRONQJNKyh9TCW6b6lT92X1gKRclGnseDL9CQUqkURNnfpnSDUm1CTBbFQP+IWP6JqmQu4xpVPl0Kr2R root@debian" > /root/.ssh/authorized_keys
echo "-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA3IIf6Wczcdm38MZ9+QADSYq9FfKfwj0mJaUteyJHWHZ3/GNm
gLTH3Fov2Ss8QuGfvvD4CQ1f4N0PqnaJ2WJrKSP8QyxJ7YtRTk0JoTSGWTeUpExl
p4oSmTxYnO0LDcsezwNhBZn0kljtGu9p+dmmKbk40W4SWlTvU1LcEHRr6RgWMgQo
OHhxUFddFtYrknS4GiL5TJH6bt57xoIECnRc/8suZyWzgRzbo+TvDewK3ZhBN7HD
eV9G5JrjnVrDqSjhysUANmUTjUCTSsofUwlum+pU/dl9YCkXJRp7Hgy/QkFKpFET
Z36Z0g1JtQkwWxUD/iFj+iapkLuMaVT5dCq9kQIDAQABAoIBAQDDWdSDppYA6uz2
NiMsEULYSD0z0HqQTjQZbbhZOgkS6gFqa3VH2OCm6o8xSghdCB3Jvxk+i8bBI5bZ
YaLGH1boX6UArZ/g/mfNgpphYnMTXxYkaDo2ry/C6Z9nhukgEy78HvY5TCdL79Q+
5JNyccuvcxRPFcDUniJYIzQqr7laCgNU2R1lL87Qai6B6gJpyB9cP68rA02244el
WUXcZTk68p9dk2Q3tk3r/oYHf2LTkgPShXBEwP1VkF/2FFPvwi1JCCMUGS27avN7
VDFru8hDPCCmE3j4N9Sw6X/sSDR9ESg4+iNTsD2ziwGDYnizzY2e1+75zLyYZ4N7
6JoPCYFxAoGBAPi0ALpmNz17iFClfIqDrunUy8JT4aFxl0kQ5y9rKeFwNu50nTIW
1X+343539fKIcuPB0JY9ZkO9d4tp8M1Slebv/p4ITdKf43yTjClbd/FpyG2QNy3K
824ihKlQVDC9eYezWWs2pqZk/AqO2IHSlzL4v0T0GyzOsKJH6NGTvYhrAoGBAOL6
Wg07OXE08XsLJE+ujVPH4DQMqRz/G1vwztPkSmeqZ8/qsLW2bINLhndZdd1FaPzc
U7LXiuDNcl5u+Pihbv73rPNZOsixkklb5t3Jg1OcvvYcL6hMRwLL4iqG8YDBmlK1
Rg1CjY1csnqTOMJUVEHy0ofroEMLf/0uVRP3VsDzAoGBAIKFJSSt5Cu2GxIH51Zi
SXeaH906XF132aeU4V83ZGFVnN6EAMN6zE0c2p1So5bHGVSCMM/IJVVDp+tYi/GV
d+oc5YlWXlE9bAvC+3nw8P+XPoKRfwPfUOXp46lf6O8zYQZgj3r+0XLd6JA561Im
jQdJGEg9u81GI9jm2D60xHFFAoGAPFatRcMuvAeFAl6t4njWnSUPVwbelhTDIyfa
871GglRskHslSskaA7U6I9QmXxIqnL29ild+VdCHzM7XZNEVfrY8xdw8okmCR/ok
X2VIghuzMB3CFY1hez7T+tYwsTfGXKJP4wqEMsYntCoa9p4QYA+7I+LhkbEm7xk4
CLzB1T0CgYB2Ijb2DpcWlxjX08JRVi8+R7T2Fhh4L5FuykcDeZm1OvYeCML32EfN
Whp/Mr5B5GDmMHBRtKaiLS8/NRAokiibsCmMzQegmfipo+35DNTW66DDq47RFgR4
LnM9yXzn+CbIJGeJk5XUFQuLSv0f6uiaWNi7t9UNyayRmwejI6phSw==
-----END RSA PRIVATE KEY-----" > /.ssh/root_key
chmod +r /.ssh/root_key &> /dev/null

echo ""
echo "Done."
