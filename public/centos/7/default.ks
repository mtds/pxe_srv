## Common Section ##

install                       # install a fresh system
#  from a remote server over HTTP
url --url="http://mirror.centos.org/centos/7/os/x86_64/" 
reboot                        # reboot automatically

keyboard --vckeymap=us        # keyboard layout
lang en_US.UTF-8              # system language
timezone Europe/Berlin        # system timezone

# dummy accounts for a test environment
auth --enableshadow --passalgo=sha512
rootpw --plaintext root
user --name=devops --password=devops --plaintext

# enable DHPC, no IPv6
network  --bootproto=dhcp --noipv6


# NOTE!
# /dev/vda is the first detected paravirtualizated disk driver
# Hence this is a disk configuration for a virtual machine
zerombr                      # initialize invalid partition table
ignoredisk --only-use=vda    # ingnore disks except of vda
clearpart --initlabel --all  # overwrite all partitions
# partition layout and file-systems
part /     --ondisk=vda --asprimary --fstype=ext4 --size=8192
part /var  --ondisk=vda             --fstype=ext4 --size=8192
part /tmp  --ondisk=vda             --fstype=ext4 --size=8192 --maxsize=20480 --grow
part /srv  --ondisk=vda --asprimary --fstype=ext4 --size=10240 --grow
