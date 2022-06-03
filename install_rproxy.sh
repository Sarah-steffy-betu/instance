#!/bin/bash

yum update -y
yum install -y haproxy
systemctl enable --now haproxy

git clone <##GIT_URL##>
