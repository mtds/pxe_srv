# Debian-Installer

[Debian-installer][installer] is designed for automation by providing preseeding information for non-interactive installation of packages. 

* [Debian Wiki - Debian Installer Pressed][pressed]
* [Debian Installation Guide - Appendix Preseed][appendix]
* [Debian Handbook - Automated Installation][debbook]

plain-text pressed file contain answers to [debconf][debconf] for configuration options during installation.

Debian-installer related configuration lines require a prefix `d-i [identifier] [type] [answer]` 

### Configuration Identifiers

Search for preseed configuration identifiers with the [debconf-get-selections][getsel] command. 

Option `--installer` prints a list of all identifiers used by Debian-Installer: 

```bash
# configuration for the ntp-server package
>>> debconf-get-selections --installer  | grep ntp-server
clock-setup     clock-setup/ntp-server  string  0.debian.pool.ntp.org
```

### Network Console

The [network console][netcon] enables SSH during installation with following configuration in the preseed file (i.e. [stretch/debug](stretch/debug)):

```
d-i anna/choose_modules string network-console
d-i preseed/early_command string anna-install network-console
d-i network-console/password password r00tme
d-i network-console/password-again password r00tme
```

## Load a Pressed File

Among the methods to **load a preseed configuration** file is fetching it from an URL by providing a kernel boot parameter, e.g.: 

```
[…] auto=true url=http:/server:<port>/path/to/pressed.cfg […]
```

When running debian-installer interactively press **ESC on the Debian Boot Screen** to adjust the debian-installer parameters. Append `auto url=http://…/preseed.cfg` as option to load a preseed configuration and hit ENTER.

Alternatively append the kernel parameters in an iPXE configuration file, i.e. [stretch/default](stretch/default)


[appendix]: https://www.debian.org/releases/stable/amd64/apb.html.en
[pressed]: https://wiki.debian.org/DebianInstaller/Preseed
[debbook]: https://debian-handbook.info/browse/stable/sect.automated-installation.html
[debconf]: https://manpages.debian.org/stretch/debconf/debconf.1.en.html
[installer]: https://www.debian.org/devel/debian-installer/
[netcon]: https://wiki.debian.org/DebianInstaller/NetworkConsole
[getsel]: https://manpages.debian.org/stretch/debconf-utils/debconf-get-selections.1.en.html
