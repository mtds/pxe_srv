export QEMU_PXE_OPTION_ROM=/usr/share/qemu/pxe-rtl8139.rom
export QEMU_DISK=/tmp/disk.qcow2

# start a VM with a iPXE boot menu
vm-boot-pxe() {
        echo Kill VM with ctrl-alt-q... 
        qemu-img create -f qcow2 $QEMU_DISK 10G
        qemu-system-x86_64 \
                -m 2G \
                -drive file=$QEMU_DISK,if=virtio,cache=writeback \
                -netdev user,id=n0,ipv6=off,net=10.0.2.0/24,hostname=lxdev01 \
                -device virtio-net,netdev=n0 \
                -boot n \
                -option-rom $QEMU_PXE_OPTION_ROM
}
