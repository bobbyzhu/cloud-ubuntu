#!/bin/bash

mkdir /var/run/sshd

id -u ubuntu &>/dev/null || useradd --create-home --shell /bin/bash --user-group --groups adm,sudo ubuntu

[ -z "$UNIX_PWD" ] && UNIX_PWD=ubuntu

/bin/echo "ubuntu:$UNIX_PWD" | /usr/sbin/chpasswd

[ -z "$VNC_PWD" ] && VNC_PWD=ubuntu

[ ! -d /home/ubuntu/.vnc ] && sudo -u ubuntu mkdir -p /home/ubuntu/.vnc
sudo -u ubuntu /usr/bin/x11vnc -storepasswd $VNC_PWD  /home/ubuntu/.vnc/passwd

sudo -u ubuntu -i bash -c "mkdir -p /home/ubuntu/.config/pcmanfm/LXDE/ \
    && mkdir -p  /home/ubuntu/.config/lxpanel/LXDE/panels \
    && cp /usr/share/desktop/desktop-items-0.conf /home/ubuntu/.config/pcmanfm/LXDE/ \
    && cp /usr/share/desktop/panel /home/ubuntu/.config/lxpanel/LXDE/panels/panel"

# /tmp
mount -t tmpfs none /tmp

# Must follow the below order to let fail2ban work normally
service rsyslog start
service ssh restart
service fail2ban start

# Set tty.js user/password
[ -z "$TTY_PWD" ] && TTY_PWD=ubuntu
sed -i -e "s/TTY_PWD/$TTY_PWD/g" /tty.js/config.json

/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

for f in /etc/startup.aux/*.sh
do
    . $f
done
