
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

ifeq (,$(A23_CXX))
A23_CXX=arm-none-eabi-g++
endif
ifeq (,$(A23_AR))
A23_AR=arm-none-eabi-ar
endif

A23_CXXFLAGS += -march=armv2a -mno-thumb-interwork -ffreestanding

LINK=$(CXX)
DLLOUT=-shared

SOCBLOX_OBJDIR=$(SOCBLOX)/objs/$(PLATFORM)
SOCBLOX_LIBDIR=$(SOCBLOX)/libs/$(PLATFORM)

SOCBLOX_A23_LIBDIR=$(SOCBLOX)/libs/a23
SOCBLOX_A23_OBJDIR=$(SOCBLOX)/objs/a23

# CXXFLAGS += -I$(SYSTEMC)/include
CXXFLAGS += -g
CXXFLAGS += -I$(VERILATOR_ROOT)/include
CXXFLAGS += -I$(VERILATOR_ROOT)/include/vltstd
CXXFLAGS += -std=c++0x
