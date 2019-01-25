IPXE_SOURCE_REPO=https://git.ipxe.org/ipxe.git
IPXE_HOME=https://boot.ipxe.org
IPXE_SOURCE=${IPXE_SOURCE:-/tmp/ipxe}

ipxe-build-from-source() {
        # build dependencies on Debian
        if command -v apt |:
        then
               sudo apt -y \
                       install \
                       build-essential \
                       liblzma-dev \
                       genisoimage \
                       git-core 
        fi

        # Download the source code
        git clone $IPXE_SOURCE_REPO $IPXE_SOURCE
        # build iPXE from source
        cd $IPXE_SOURCE/src
        make |& tee ../build.log
        # copy components to HTTP server document root
        cp -v bin/*.{iso,usb,pxe,lkrn} $PXESRV_ROOT/
        # clean up
        cd -
        rm -rf $IPXE_SOURCE
}

# download the iPXE roms from the official web-site
ipxe-download() {
        for file in ipxe.{iso,usb,dsk,efi,lkrn,pxe}
        do
                curl --silent \
                     --show-error \
                     --output $PXESRV_ROOT/$file \
                     $IPXE_HOME/$file
                ls -1 $PXESRV_ROOT/$file
        done
}

# kill with Esc+2 (monitor console), `quit` command
ipxe-vm-instance() {
        echo Access QEMU/monitor with ESC+2
        sleep 2
        kvm \
                -m 2048 \
                 --curses \
                $PXESRV_ROOT/ipxe.iso 
}
