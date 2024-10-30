OS_TYPE := $(shell uname -s)

ifeq ($(OS_TYPE),Darwin)
    include Makefile.mac
else
    include Makefile.linux
endif
include Makefile.common
include Makefile.doxygen
