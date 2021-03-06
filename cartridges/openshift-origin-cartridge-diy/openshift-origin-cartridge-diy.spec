%global cartridgedir %{_libexecdir}/openshift/cartridges/v2/diy-0.1
%global frameworkdir %{_libexecdir}/openshift/cartridges/v2/diy-0.1

Name: openshift-origin-cartridge-diy
Version: 0.1.3
Release: 1%{?dist}
Summary: Php cartridge
Group: Development/Languages
License: ASL 2.0
URL: https://openshift.redhat.com
Source0: http://mirror.openshift.com/pub/origin-server/source/%{name}/%{name}-%{version}.tar.gz
Requires:      openshift-origin-cartridge-abstract
Requires:      rubygem(openshift-origin-node)
Requires:      httpd < 2.4

BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
BuildArch: noarch

%description
PHP cartridge for openshift.


%prep
%setup -q

%build

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}%{cartridgedir}
mkdir -p %{buildroot}/%{_sysconfdir}/openshift/cartridges
cp -r * %{buildroot}%{cartridgedir}/


%clean
rm -rf %{buildroot}


%files
%defattr(-,root,root,-)
%dir %{cartridgedir}
%dir %{cartridgedir}/bin
%dir %{cartridgedir}/env
%dir %{cartridgedir}/metadata
%dir %{cartridgedir}/versions
%attr(0755,-,-) %{cartridgedir}/bin/
%attr(0755,-,-) %{frameworkdir}
%{cartridgedir}/metadata/manifest.yml
%doc %{cartridgedir}/README.md
%doc %{cartridgedir}/COPYRIGHT
%doc %{cartridgedir}/LICENSE


%changelog
* Fri Mar 15 2013 Dan McPherson <dmcphers@redhat.com> 0.1.3-1
- new package built with tito

* Fri Mar 15 2013 Troy Dawson <tdawson@redhat.com> 0.1.2-1
- new package built with tito

* Thu Mar 14 2013 Chris Alfonso <chris@@hoflabs.com> 0.1.1-1
- new package built with tito

