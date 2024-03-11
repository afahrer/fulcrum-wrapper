#!/bin/sh

set -e

configurator

exec tini Fulcrum
