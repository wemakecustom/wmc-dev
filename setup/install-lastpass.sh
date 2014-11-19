#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

if [ ! -x /usr/bin/lpass ]; then
    sudo aptitude -y install openssl libcurl4-openssl-dev libxml2 libssl-dev libxml2-dev pinentry-curses

    tmp="$(mktemp -d)"

    git clone https://github.com/lastpass/lastpass-cli.git "${tmp}"

    cd "${tmp}"

    make && sudo make install

    rm -Rf "${tmp}"
fi
