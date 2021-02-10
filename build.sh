#!/bin/bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker build --rm -t etaylashev/dns-demo  $DIR

exit 0
