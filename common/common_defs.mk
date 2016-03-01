
# Determine the platform
COMMON_DEFS_MK := $(lastword $(MAKEFILE_LIST))
COMMON_DEFS_MK_DIR := $(dir $(COMMON_DEFS_MK))

include $(COMMON_DEFS_MK_DIR)/plusargs.mk

OS=$(shell uname -o)
ARCH=$(shell uname -m)

ifeq (Cygwin,$(OS))
  DYNLINK=false
  ifeq ($(ARCH), x86_64)
    PLATFORM=cygwin64
  else
    PLATFORM=cygwin
  endif
else # Linux
ifeq ($(shell uname),Linux)
  DYNLINK=true
  ifeq ($(ARCH), x86_64)
    PLATFORM=linux_x86_64
  else
    PLATFORM=linux
  endif
else
  PLATFORM=unknown
endif
endif


ifeq (Cygwin,$(OS))
  ifeq ($(ARCH),x86_64)
    SYSTEMC_LIBDIR=$(SYSTEMC)/lib-cygwin64
  else
    SYSTEMC_LIBDIR=$(SYSTEMC)/lib-cygwin
  endif
  SYSTEMC_LIB=$(SYSTEMC_LIBDIR)/libsystemc.a
  LINK_SYSTEMC=$(SYSTEMC_LIBDIR)/libsystemc.a
endif

ifeq ($(PLATFORM),win32) 
DLLEXT=.dll
else
DLLEXT=.so
LIBPREF=lib
endif

ifeq (,$(A23_CXX))
A23_CXX=arm-none-eabi-g++
endif
ifeq (,$(A23_AR))
A23_AR=arm-none-eabi-ar
endif

# ifneq (,$(PLUSARG_FILES))
# PLUSARGS:=$(shell $(SOCBLOX)/common/scripts/argfile.pl $(PLUSARGS_FILES))
# endif

A23_CXXFLAGS += -march=armv2a -mno-thumb-interwork -ffreestanding

LINK=$(CXX)
DLLOUT=-shared

SOCBLOX_OBJDIR=$(SOCBLOX)/objs/$(PLATFORM)
SOCBLOX_LIBDIR=$(SOCBLOX)/libs/$(PLATFORM)

SOCBLOX_A23_LIBDIR=$(SOCBLOX)/libs/a23
SOCBLOX_A23_OBJDIR=$(SOCBLOX)/objs/a23

# CXXFLAGS += -I$(SYSTEMC)/include
ifneq (Cygwin,$(OS))
CXXFLAGS += -fPIC
else
CXXFLAGS += -Wno-attributes
endif

CXXFLAGS += -g
CXXFLAGS += -I$(VERILATOR_ROOT)/include
CXXFLAGS += -I$(VERILATOR_ROOT)/include/vltstd
CXXFLAGS += -std=c++0x

VERBOSE=true

ifeq (false,$(VERBOSE))
Q=@
endif

