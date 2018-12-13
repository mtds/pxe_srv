
Debian-installer is designed for automation by providing preseeding information for non-interactive installation of packages. 

* [Debian Wiki - Debian Installer Pressed][pressed]
* Debian Installation Guide - Appendix Preseed [01]
* [Debian Handbook - Automated Installation][debbook]

The preseeding information is provided in a plain-text file. Basically these files contain answers to [debconf][debconf] questions for packages configured during installation.

Debian-installer related configuration lines require a prefixe `d-i [identifier] [type] [answer]` 

Among the methods to **load a preseed configuration** file is fetching it from an URL by providing a kernel boot parameter, e.g.: 

```
[…] auto=true url=http:/server:<port>/path/to/pressed.cfg […]
```

When running debian-installer interactively press **ESC on the Debian Boot Screen** to adjust the debian-installer parameters. Append `auto url=http://…/preseed.cfg` as option to load a preseed configuration and hit ENTER.

Alternatively append the kernel parameters in an iPXE configuration file, i.e. [stretch/ipxe](stretch/ipxe)


[01]: https://www.debian.org/releases/stable/amd64/apb.html.en
[pressed]: https://wiki.debian.org/DebianInstaller/Preseed
[debbook]: https://debian-handbook.info/browse/stable/sect.automated-installation.html
[debconf]: https://manpages.debian.org/stretch/debconf/debconf.1.en.html
