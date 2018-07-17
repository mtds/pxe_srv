QEMU_PXE_OPTION_ROM=/usr/share/qemu/pxe-rtl8139.rom
QEMU_DISK=/tmp/disk.qcow2
QEMU_NETWORK=10.0.2.0/24
QEMU_HOST_IP=10.0.2.2

export QEMU_PXE_OPTION_ROM \
       QEMU_DISK \
       QEMU_NETWORK \
       QEMU_HOST_IP

# start a VM with a iPXE boot menu
vm-boot-pxe() {
        echo Kill VM with ctrl-alt-q... 
        qemu-img create -f qcow2 $QEMU_DISK 10G
        qemu-system-x86_64 \
                -m 2G \
                -boot n \
                -drive file=$QEMU_DISK,if=virtio,cache=writeback \
                -netdev user,id=n0,ipv6=off,net=$QEMU_NETOWRK,host=$QEMU_HOST_IP \
                -device virtio-net,netdev=n0 \
                -option-rom $QEMU_PXE_OPTION_ROM
}
