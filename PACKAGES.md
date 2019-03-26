## RPM

Build an RPM package from [pxesrv.spec](pxesrv.spec)

```bash
# install package build tool chain
yum install -y rpm-build
# build the package
rpmbuild -bb pxesrv.spec
# show the package content
rpm -qipl $package
```

## Debian

Build a Debian package with file in [debian][debian/]:

```bash
# install package build tool chain
apt -y install debhelper devscripts dh-systemd
# build the package
dpkg-buildpackage -b -us -uc -tc
# show package content
dpkg -c ../pxesrv_*.deb
```
