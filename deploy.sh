#!/bin/bash

deploy() {
    local ip=$1
    local PKG=$2

    ssh -p 8022 ${ip} "mkdir -p \${HOME}/.config/my_services/common"
    ssh -p 8022 ${ip} "cat > \${HOME}/.config/my_services/common/parse.sh" < "common/parse.sh"

    ssh -p 8022 ${ip} "mkdir -p \${HOME}/.config/my_services/${PKG}"
    ssh -p 8022 ${ip} "cat > \${HOME}/.config/my_services/${PKG}/config.ini" < "${PKG}/config.ini"

    ssh -p 8022 ${ip} bash << EOF
        mkdir -p \${PREFIX}/var/service/${PKG}/log
        ln -sf \${PREFIX}/share/termux-services/svlogger \${PREFIX}/var/service/${PKG}/log/run
EOF
    ssh -p 8022 ${ip} "cat > \${PREFIX}/var/service/${PKG}/run" < "${PKG}/run.sh"
    ssh -p 8022 ${ip} bash << EOF
        chmod +x \${PREFIX}/var/service/${PKG}/run
        SVDIR=\${PREFIX}/var/service sv-enable ${PKG}
        SVDIR=\${PREFIX}/var/service sv down ${PKG}
        SVDIR=\${PREFIX}/var/service sv up ${PKG}
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

ip=${1}
PKG=${2}
deploy ${ip} ${PKG}
boot ${ip}
