#!/usr/bin/env bash

set -eu -o pipefail

# `man apt.conf`:
#   Number of retries to perform. If this is non-zero APT will retry
#   failed files the given number of times.
echo 'Acquire::Retries "3";' | sudo tee /etc/apt/apt.conf.d/80-retries

# Ref.: https://rocm.docs.amd.com/projects/install-on-linux/en/latest/how-to/native-install/ubuntu.html

# Make the directory if it doesn't exist yet.
# This location is recommended by the distribution maintainers.
sudo mkdir --parents --mode=0755 /etc/apt/keyrings

# Download the key, convert the signing-key to a full
# keyring required by apt and store in the keyring directory
wget https://repo.radeon.com/rocm/rocm.gpg.key -O - | \
    gpg --dearmor | sudo tee /etc/apt/keyrings/rocm.gpg > /dev/null

curl -O https://repo.radeon.com/rocm/rocm.gpg.key
sudo apt-key add rocm.gpg.key

source /etc/os-release # set UBUNTU_CODENAME: focal or jammy or ...

echo "deb [arch=amd64] https://repo.radeon.com/rocm/apt/${1-latest} ${UBUNTU_CODENAME} main" \
  | sudo tee /etc/apt/sources.list.d/rocm.list

echo -e 'Package: *\nPin: release o=repo.radeon.com\nPin-Priority: 600' | sudo tee /etc/apt/preferences.d/rocm-pin-600

sudo apt-get update
sudo apt-get install -y --no-install-recommends \
    build-essential \
    cmake           \
    rocm-dev
