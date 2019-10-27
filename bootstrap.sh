#!/bin/bash

export PROCESS="amd64"
if [[ $(cat /sys/firmware/devicetree/base/model;echo) == "Raspberry Pi"* ]];
then
  export PROCESS="arm"
fi

export DEBIAN_FRONTEND=noninteractive

if ! [ -x "$(command -v node)" ]; then
  curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -
  sudo apt install nodejs
fi

UPGRADE_PACKAGES=${1:-none}

if [ "${UPGRADE_PACKAGES}" != "none" ]; then
  echo "==> Updating and upgrading packages ..."

  # Add third party repositories
  sudo add-apt-repository ppa:keithw/mosh-dev -y
  sudo add-apt-repository ppa:jonathonf/vim -y

  sudo apt-get update
  sudo apt-get upgrade -y
fi

sudo apt-get install -y  \
  libtool       \
  libsodium13   \
  curl          \
  docker.io     \
  git           \
  jq            \
  mosh          \
  tmux          \
  wget          \
  --no-install-recommends
#
#rm -rf /var/lib/apt/lists/*

# install 1password
if ! [ -x "$(command -v op)" ]; then
  export OP_VERSION="v0.6.1"
  curl -sS -o 1password.zip \
  https://cache.agilebits.com/dist/1P/op/pkg/${OP_VERSION}/op_linux_${PROCESS}_${OP_VERSION}.zip
  unzip 1password.zip op -d /usr/local/bin
  rm -f 1password.zip
fi

if [ -d "~/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL  https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
fi 
