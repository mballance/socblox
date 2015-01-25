
ARCH?=arm-altera-eabi-
CC=$(ARCH)gcc
CXX=$(ARCH)g++
OBJCOPY=$(ARCH)objcopy
LD=$(ARCH)ld

pwd := $(shell pwd)
SRCDIRS += $(pwd)/src $(HWLIBS_ROOT)/src/hwmgr
SRCDIRS += $(pwd)/../ulink
SRCDIRS += $(pwd)/src/drivers $(pwd)/src/drivers/net $(pwd)/src/drivers/serial
SRCDIRS += $(pwd)/src/net

BUILDDIR=$(pwd)/build

vpath %.cpp $(SRCDIRS)
vpath %.h  $(SRCDIRS)
vpath %.c $(SRCDIRS)
vpath %.S $(SRCDIRS)
vpath %.elf $(BUILDDIR)

THUMB=1

CFLAGS += -g

ifeq (1,$(THUMB))
ARM_LIBGCC:=$(shell $(CC) -mthumb -mthumb-interwork -print-libgcc-file-name)
ARM_LIBC:=$(dir $(ARM_LIBGCC))/../../../../../arm-altera-eabi/lib/thumb/libc.a
CFLAGS += -mthumb -mthumb-interwork
else
ARM_LIBGCC:=$(shell $(CC) -mno-thumb-interwork -print-libgcc-file-name)
ARM_LIBC:=$(dir $(ARM_LIBGCC))/../../../../arm-altera-eabi/lib/libc.a
CFLAGS += -mno-thumb-interwork
endif

INCDIRS += $(SRCDIRS)

# INCDIRS += $(pwd)/build/uboot-socfpga/board/altera/socfpga
# INCDIRS += $(pwd)/build/uboot-socfpga/board/altera/socfpga/sdram
# INCDIRS += $(pwd)/build/uboot-socfpga/include
CFLAGS += $(foreach i,$(INCDIRS),-I$(i))
CFLAGS += -ffixed-r8 -msoft-float -D__KERNEL__ 
# CFLAGS += -ffixed-r8 -msoft-float -D__KERNEL__ 
# CFLAGS += -DDEBUG=0 -DCONFIG_SYS_TEXT_BASE=0x01000040 -DCONFIG_SPL_TEXT_BASE=0xFFFF0000 
CFLAGS += -fno-builtin -ffreestanding 
# -nostdinc 
# -isystem /scratch2/tools/quartus/14.0/embedded/host_tools/mentor/gnu/arm/baremetal/bin/../lib/gcc/arm-altera-eabi/4.9.1/include -pipe  
CFLAGS += -DCONFIG_ARM -D__ARM__ -mthumb-interwork -mabi=aapcs-linux 
CFLAGS += -march=armv7-a -Wall -Wstrict-prototypes -fno-stack-protector 
CFLAGS += -Wno-format-nonliteral -Wno-format-security -fstack-usage 
CFLAGS += -fno-toplevel-reorder

CXXFLAGS += $(CFLAGS)

all : $(BUILDDIR)/fpgamgr.bin

%.bin : %.elf
	$(OBJCOPY) -O binary $^ $@

FPGAMGR_OBJS = \
  ub_crt0.o \
  io_stubs.o \
  uart_debug.o \
  \
  designware_eth_drv.o \
  \
  net_packet.o \
  net_stack.o \
  \
  fpgamgr.o
	
$(BUILDDIR)/fpgamgr.elf : $(foreach o,$(FPGAMGR_OBJS),$(BUILDDIR)/$o)
	@if test ! -d $(BUILDDIR); then mkdir -p $(BUILDDIR); fi
	$(CXX) $(LDFLAGS) -o $@ $^ \
		-T$(pwd)/ub.lds $(ARM_LIBC) $(ARM_LIBGCC)


$(BUILDDIR)/%.o : %.S
	@if test ! -d $(BUILDDIR); then mkdir -p $(BUILDDIR); fi
	$(CC) -c -o $@ $^
	
$(BUILDDIR)/%.o : %.c
	@if test ! -d $(BUILDDIR); then mkdir -p $(BUILDDIR); fi
	$(CC) -c $(CFLAGS) $^ -o $@

$(BUILDDIR)/%.o : %.cpp
	@if test ! -d $(BUILDDIR); then mkdir -p $(BUILDDIR); fi
	$(CXX) -c $(CXXFLAGS) $^ -o $@
	
clean :
	rm -rf $(BUILDDIR)
