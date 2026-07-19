#!/bin/bash

clock() {
    local ip=$1
    local ring=$2
    local PKG='clock'

    ssh -p 8022 ${ip} bash << EOF
        mkdir -p \${PREFIX}/var/service/${PKG}/log
        ln -sf \${PREFIX}/share/termux-services/svlogger \${PREFIX}/var/service/${PKG}/log/run
EOF
    ssh -p 8022 ${ip} "cat > \${PREFIX}/var/service/${PKG}/run" < ${PKG}.sh
    ssh -p 8022 ${ip} "cat > \${HOME}/storage/music/${ring}" < ${ring}
    ssh -p 8022 ${ip} bash << EOF
        SVDIR=\${PREFIX}/var/service sv-enable ${PKG}
        chmod +x \${PREFIX}/var/service/${PKG}/run
EOF
}

boot() {
    local ip=$1
    ssh -p 8022 ${ip} "cat > \${HOME}/.termux/boot/start-services.sh" << 'EOF'
#!/data/data/com.termux/files/usr/bin/sh
termux-wake-lock
. $PREFIX/etc/profile
EOF
    ssh -p 8022 ${ip} "chmod +x \${HOME}/.termux/boot/start-services.sh"
}

ip=${1:-'192.168.71.55'}
ring=${2:-'Renatus.mp3'}
clock ${ip} ${ring}
boot ${ip}
