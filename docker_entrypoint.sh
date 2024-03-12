#!/bin/sh

set -e

TOR_ADDRESS=$(yq '.electrum-tor-address' /data/start9/config.yaml)

cat << EOF > /data/start9/stats.yaml
---
version: 2
data:
  Quick Connect URL:
    type: string
    value: $TOR_ADDRESS:50001:t
    description: For scanning or pasting into wallets such as BlueWallet or Electrum
    copyable: true
    qr: true
    masked: false
  Hostname:
    type: string
    value: $TOR_ADDRESS
    description: Hostname to input into wallet software such as Sparrow.
    copyable: true
    qr: false
    masked: false
  Port:
    type: string
    value: "50001"
    description: Port to input into wallet software such as Sparrow.
    copyable: true
    qr: false
    masked: false
EOF

configurator
FulcrumAdmin -h
exec tini Fulcrum fulcrum.conf
