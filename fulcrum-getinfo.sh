#!/bin/sh

set -e

FulcrumAdmin -p 8000 getinfo >&2
exit 61

