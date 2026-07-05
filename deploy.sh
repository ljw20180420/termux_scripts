#!/bin/bash

deploy() {
    local ip=$1
    local ring=$2
    local PKG=$3

    ssh -p 8022 ${ip} bash << EOF
        mkdir -p \${PREFIX}/var/service/${PKG}/log
        ln -sf \${PREFIX}/share/termux-services/svlogger \${PREFIX}/var/service/${PKG}/log/run
        mkdir -p \${HOME}/.config/${PKG}
EOF
    ssh -p 8022 ${ip} "cat > \${PREFIX}/var/service/${PKG}/run" < ${PKG}.sh
    ssh -p 8022 ${ip} "cat > \${HOME}/.config/${PKG}/${ring}" < ${ring}
    ssh -p 8022 ${ip} bash << EOF
        SVDIR=\${PREFIX}/var/service sv-enable ${PKG}
        chmod +x \${PREFIX}/var/service/${PKG}/run
EOF
}

ip=${1:-'192.168.71.28'}
ring=${2:-'Renatus.mp3'}
PKG=${3:-'clock'}
deploy ${ip} ${ring} $PKG
