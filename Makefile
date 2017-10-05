BUILDER ?= gprbuild -p -gnat12 -gnata
FLAGS ?=
ifeq (${DEBUG}, True)
	FLAGS +=  -gnata -ggdb -g 
else
	DEBUG = False
endif
NAME = nanomsgada
PROJECT ?= ${NAME}
DESTDIR ?= 
prefix ?= /usr/local
libdir ?= ${prefix}/lib
bindir ?= ${prefix}/bin
includedir ?= ${prefix}/include
gprdir ?= ${prefix}/share/gpr
VERSION = 0.1
export LIBRARY_TYPE ?= relocatable
INSTALLER ?=  gprinstall -p --prefix=${prefix} --sources-subdir=${includedir}/${NAME} \
			--link-lib-subdir=${libdir} --lib-subdir=${libdir}/${NAME}

gen:
	gcc src/c/errnogen.c -o bin/errnoctoada
	./bin/errnoctoada > src/syserrors.ads
	rm -f bin/errnoctoada

build: gen
	${BUILDER} ${FLAGS} -P gnat/${PROJECT}

check: build
	${BUILDER} ${FLAGS} -P gnat/${PROJECT}_tests

clean:
	rm -rf bin/* obj/* lib/*

all: build	


clean_rpm:
	rm -rf ${HOME}/rpmbuild/SOURCES/${NAME}-${VERSION}.tgz
	rm  -f packaging/${NAME}-build.spec
	find ${HOME}/rpmbuild -name "${NAME}*.rpm" -exec rm -f {} \; 

rpm: clean_rpm
	git archive --prefix=${NAME}-${VERSION}/ -o ${HOME}/rpmbuild/SOURCES/${NAME}-${VERSION}.tar.gz HEAD
	sed "s/@RELEASE@/`date +%s`/;s/@DEBUG@/${DEBUG}/" packaging/Fedora.spec > packaging/${NAME}-build.spec
	rpmbuild -ba packaging/${NAME}-build.spec
	rm -f packaging/${NAME}-build.spec

install:
	${INSTALLER} -P gnat/${PROJECT}
