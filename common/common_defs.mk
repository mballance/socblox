
# Determine the platform

ifeq ($(shell uname),Linux)
  ifeq ($(shell uname -m), x86_64)
    PLATFORM=linux_x86_64
  else
    PLATFORM=linux
  endif
else
  PLATFORM=unknown
endif

ifeq ($(PLATFORM),win32) 
DLLEXT=.dll
else
DLLEXT=.so
LIBPREF=lib
endif

LINK=$(CXX)
DLLOUT=-shared

SOCBLOX_OBJDIR=$(SOCBLOX)/objs/$(PLATFORM)
SOCBLOX_LIBDIR=$(SOCBLOX)/libs/$(PLATFORM)

CXXFLAGS += -I$(SYSTEMC)/include
CXXFLAGS += -g
CXXFLAGS += -I$(VERILATOR_ROOT)/include
CXXFLAGS += -I$(VERILATOR_ROOT)/include/vltstd
CXXFLAGS += -std=c++0x
