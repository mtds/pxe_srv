# iPXE

[iPXE][ipxe] is a open source network boot firmware implementing [PXE][pxe], cf. iPXE [Command Reference][ipxecmd]:

Files                             | Description
----------------------------------|--------------------------------------------
[default](default)                | Default boot menu (includes [SAL's Network Boot][sal])
[centos/](centos/)                | Boot CentOS Anaconda with a custom Kickstart configuration
[debian/](debian/)                | Boot Debian-Installer with a custom Preseed configuration

Build custom iPXE from the [source code][ipxesrc] using functions from [var/aliases/ipxe.sh][ipxefunc]

[pxe]: https://en.wikipedia.org/wiki/Preboot_Execution_Environment
[ipxe]: http://ipxe.org/
[ipxecmd]: http://ipxe.org/cmd
[ipxesrc]: https://git.ipxe.org/ipxe.git
[ipxefunc]: ../var/aliases/ipxe.sh
[sal]: http://boot.salstar.sk/
