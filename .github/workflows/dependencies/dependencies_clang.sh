#!/usr/bin/env bash

set -eu -o pipefail

# `man apt.conf`:
#   Number of retries to perform. If this is non-zero APT will retry
#   failed files the given number of times.
echo 'Acquire::Retries "3";' | sudo tee /etc/apt/apt.conf.d/80-retries

sudo apt-get update

sudo apt-get install -y --no-install-recommends \
    build-essential      \
    cmake                \
    clang
