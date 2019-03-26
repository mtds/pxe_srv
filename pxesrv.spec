Name:           pxesrv
Version:        0.2
Release:        1
Summary:        PXE Boot service
License:        GNU General Public License v3.0
URL:            https://github.com/vpenso/pxesrv
BuildArch:      noarch
Requires:       epel-release rubygem-sinatra
Source:         %{expand:%%(pwd)}

%description
PXESrv is a Sinatra HTTP server hosting iPXE network boot configurations

%prep
mkdir -p %{buildroot}/usr/sbin
cp %{SOURCEURL0}/pxesrv %{buildroot}/usr/sbin/pxesrv
mkdir -p %{buildroot}/etc/systemd/system
cp %{SOURCEURL0}/var/systemd/pxesrv.service %{buildroot}/etc/systemd/system/pxesrv.service

%postun
/usr/bin/systemctl daemon-reload >/dev/null 2>&1 ||:

%files
%attr(0755, root, root) /usr/sbin/pxesrv
%attr(0755, root, root) /etc/systemd/system/pxesrv.service
