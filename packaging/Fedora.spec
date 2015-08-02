Name:		nanomsgada
Version:	0.1
Release:	1.@RELEASE@%{?dist}
Summary:	Thin binding to nanomsg library

Group:		Development/Libraries
License:	GPLv3+
URL:		http://github.com/landgraf/nanomsg-ada.git
Source0:	%{name}-%{version}.tar.gz

BuildRequires:	gcc-gnat > 4.8
BuildRequires: gprbuild
BuildRequires:  fedora-gnat-project-common > 3
BuildRequires:  nanomsg-devel
BuildRequires:  aunit-devel

%description
%{summary}

%package devel
Summary: 	Devel package for %{name}
License:        GPLv3
Group:          Development/Libraries
Requires:   %{name}%{?_isa} = %{version}-%{release}

%description devel
%{summary}

%prep
%setup -q


%build
export FLAGS="%GPRbuild_optflags"
export DEBUG=%{debug}
make %{?_smp_mflags}


%install
%make_install prefix=%{buildroot}/%{_prefix} libdir=%{buildroot}/%{_libdir}
cd %{buildroot}/%{_libdir} && ln -s %{name}/lib%{name}.so.%{version} .

%check
make check

%post -p /sbin/ldconfig

%postun -p /sbin/ldconfig


%files
%doc LICENSE
%dir %{_libdir}/%{name}
%{_libdir}/lib%{name}*.so.%{version}
%{_libdir}/%{name}/lib%{name}*.so.%{version}

%files devel
%doc README.md
%{_libdir}/lib%{name}*.so.?
%{_libdir}/lib%{name}*.so
%{_libdir}/%{name}/lib%{name}*.so.?
%{_libdir}/%{name}/lib%{name}*.so
%{_libdir}/%{name}/*.ali
%{_includedir}/%{name}
%{_docdir}/%{name}
%{_GNAT_project_dir}/%{name}*
%doc


%changelog
* Mon Dec 16 2013 Pavel Zhukov <landgraf@fedoraproject.org> - 0.1-1
- Initial build

