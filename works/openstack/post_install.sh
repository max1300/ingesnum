#!/bin/bash

ELAO_USER=elao
DEFAULT_USER=debian
MANALA_PGP_KEY_ID=1394DEA3

# Get release
RELEASE_CODENAME=$(cat /etc/os-release | sed -n 's/.*VERSION="[0-9] (\(.*\))"/\1/p')

# Manala apt source
DIR=$(cd $(dirname $0) && pwd)

apt-get update

case ${RELEASE_CODENAME} in
wheezy|jessie)
  apt-get --quiet --verbose-versions --yes --no-install-recommends install apt-utils apt-transport-https gnupg
  ;;
stretch)
  apt-get --quiet --verbose-versions --yes --no-install-recommends install apt-utils apt-transport-https gnupg dirmngr
  ;;
esac

eval "sudo cat > /etc/apt/sources.list.d/debian_manala_io.list <<-EOF
deb [arch=amd64] http://debian.manala.io ${RELEASE_CODENAME} main
EOF"

apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 ${MANALA_PGP_KEY_ID}

# Requirements
apt-get update && apt-get install --no-install-recommends -y python python-apt perl-modules libpam-ssh-agent-auth vim git
