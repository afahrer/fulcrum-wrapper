#!/bin/sh

set -e

configurator
cat /data/start9/config.yaml
cat fulcrum.conf
exec tini ./Fulcrum fulcrum.conf
