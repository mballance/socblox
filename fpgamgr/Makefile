#****************************************************************************
#* Makefile
#*
#* Builds 
#****************************************************************************
MULTILIBFLAGS := -mcpu=cortex-a9 -mfloat-abi=softfp -mfpu=neon
HWLIBS_ROOT ?= $(SOCEDS_ROOT)/ip/altera/hps/altera_hps/hwlib

BUILDDIR=$(shell pwd)/build
ARCH?=arm-altera-eabi-
CXX=$(ARCH)g++
CC=$(ARCH)gcc
OBJCOPY=$(ARCH)objcopy

INCDIRS += src $(HWLIBS_ROOT)/include

CXXFLAGS += $(MULTILIBFLAGS) -std=c++11
CXXFLAGS += $(foreach i,$(INCDIRS),-I$(i))

CFLAGS += $(MULTILIBFLAGS) -std=c99
CFLAGS += $(foreach i,$(INCDIRS),-I$(i))

#  io_stubs.o \


FPGAMGR_OBJ = \
  fpgamgr.o \
  \
  alt_fpga_manager.o \
  alt_bridge_manager.o \
  alt_16550_uart.o \
  alt_clock_manager.o \
  alt_interrupt.o 
  
  

all : $(BUILDDIR)/fpgamgr.bin

clean :
	rm -rf build

$(BUILDDIR)/fpgamgr.elf : $(foreach o,$(FPGAMGR_OBJ),$(BUILDDIR)/$(o))
	$(CXX) -TcycloneV-dk-ram.ld $(MULTILIBFLAGS) -o $@ $^


vpath %.cpp %.h %.c %.S $(shell pwd)/src
vpath %.c $(HWLIBS_ROOT)/src/hwmgr
vpath %.elf $(BUILDDIR)

%.bin : %.elf
	$(OBJCOPY) -O binary $^ $@


$(BUILDDIR)/%.o : %.cpp
	@if test ! -d $(BUILDDIR); then mkdir -p $(BUILDDIR); fi
	$(CXX) -c $(CXXFLAGS) $^ -o $@
	
$(BUILDDIR)/%.o : %.c
	@if test ! -d $(BUILDDIR); then mkdir -p $(BUILDDIR); fi
	$(CC) -c $(CFLAGS) $^ -o $@
	
	
