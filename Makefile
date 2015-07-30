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

build:
	${BUILDER} -P gnat/${NAME}

check: build
	${BUILDER} -P gnat/${NAME}_tests

all: build	


