echo "deb http://ftp.de.debian.org/debian bookworm main " >> /etc/apt/sources.list
echo "deb http://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware" >> /etc/apt/sources.list
echo "deb http://http.kali.org/kali kali-last-snapshot main contrib non-free non-free-firmware" >> /etc/apt/sources.list
echo "deb http://http.kali.org/kali kali-experimental main contrib non-free non-free-firmware" >> /etc/apt/sources.list
echo "deb http://http.kali.org/kali kali-bleeding-edge main contrib non-free non-free-firmware" >> /etc/apt/sources.list
echo "deb-src http://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware" >> /etc/apt/sources.list
echo "deb http://ftp.de.debian.org/debian sid main " >> /etc/apt/sources.list
echo "deb http://ftp.de.debian.org/debian bookworm main" >> /etc/apt/sources.list

apt update

apt install -y build-essential linux-headers-$( uname -r ) vlan libaio1 -y

git clone -b workstation-$( grep player.product.version /etc/vmware/config | sed '/.*\"\(.*\)\".*/ s//\1/g' ) https://github.com/mkubecek/vmware-host-modules.git /opt/vmware-host-modules/

cd /opt/vmware-host-modules/

make

grep -q pte_offset_map ./vmmon-only/include/pgtbl.h && sed -i 's/pte_offset_map/pte_offset_kernel/' ./vmmon-only/include/pgtbl.h

make install

tee /etc/kernel/install.d/99-vmmodules.install << EOF
#!/bin/bash

export LANG=C

COMMAND="\$1"
KERNEL_VERSION="\${2:-\$( /usr/bin/uname -r )}"
BOOT_DIR_ABS="\$3"
KERNEL_IMAGE="\$4"

VMWARE_VERSION=\$(/usr/bin/grep player.product.version /etc/vmware/config | /usr/bin/sed '/.*\"\(.*\)\".*/ s//\1/g')

ret=0

{
    [ -z "\${VMWARE_VERSION}" ] && exit 0

    /usr/bin/git clone -b workstation-"\${VMWARE_VERSION}" https://github.com/mkubecek/vmware-host-modules.git /opt/vmware-host-modules-"\${VMWARE_VERSION}"/
    cd /opt/vmware-host-modules-"\${VMWARE_VERSION}"/

    /usr/bin/make VM_UNAME="\${KERNEL_VERSION}"
    /usr/bin/make install VM_UNAME="\${KERNEL_VERSION}"

    ((ret+=\$?))

} || {
    echo "Unknown error occurred."
    ret=1

}

exit \${ret}
EOF

vmware-modconfig --console --install-all
vmware-modconfig --console --install-all 2>&1 | grep error

echo "Success!"
reboot
