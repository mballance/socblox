
TESTS_SW_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(SOCBLOX)/units/wb_uart/sw/defs_rules.mk

ifneq (1,$(RULES))

SRC_DIRS += $(TESTS_SW_DIR) $(TESTS_SW_DIR)/baremetal

# EXE_TARGETS += smoke.mem smoke.hex smoke.elf smoke.dat

BAREMETAL_TESTS := smoke thread_primitives msg_queue_smoke \
  uth_yield_test uth_thread_swap_test svf_smoketest memmove_test \
  memaccess_test sprintf_test

# UEX_TESTS := uex_simple_thread
EXTS=.bin .mem .hex .elf .dat

EXE_TARGETS += $(foreach e, $(EXTS), $(foreach t, $(BAREMETAL_TESTS), baremetal/$(t)$(e)))
EXE_TARGETS += $(foreach e, $(EXTS), $(foreach t, $(UEX_TESTS), uex/$(t)$(e)))

else

%.o : %.S
	if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(CC) -c $^ -o $@
	
$(SVF_OBJDIR)/%.o : %.S
	if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(CC) -c $^ -o $@
	
$(SVF_OBJDIR)/%.o : %.c
	if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(CC) -c $(CFLAGS) $^ -o $@

%.mem : %.elf
	$(OBJCOPY) $^ -O verilog $@
#	perl `which objcopy_verilog_filter.pl` $@

%.bin : %.elf
	$(OBJCOPY) $^ -O binary $@

%.hex : %.elf
	$(OBJCOPY) $^ -O ihex $@
	
%.dat : %.hex
	perl $(SOCBLOX)/common/scripts/objcopy_ihex2quartus_filter.pl \
		$^ $@

# LIBC := /usr1/src/newlib/arm-none-eabi/newlib/libc.a		
# LIBC := /usr1/src/newlib_O2/arm-none-eabi/newlib/libc/libc.a		
# LIBC := /usr1/src/libc_O2.a
# LIBC := /usr1/src/libc.a
# LIBC := /usr1/src/newlib_gOs/inst/arm-none-eabi/lib/libc.a		

#	$(SVF_OBJDIR)/a23_simple_startup.o \
	
baremetal/%.elf : baremetal/%.o \
	$(SVF_OBJDIR)/a23_startup.o \
	$(SVF_OBJDIR)/io_stubs.o \
	$(SVF_OBJDIR)/uex_thread_primitives.o \
	$(SVF_OBJDIR)/a23_dualcore_low_level_init.o \
	$(SVF_OBJDIR)/a23_cpp_support.o \
	$(SVF_OBJDIR)/a23_memory.o \
	$(SVF_LIBDIR)/libtimer.a   \
	$(SVF_LIBDIR)/libintc.a		\
	$(SVF_LIBDIR)/libbidi_message_queue_drv.a \
	$(LIBSVF_UTH_AR) \
	$(UTH_COOP_THREAD_MGR_SLIB) \
	$(UTH_SLIB) \
	$(UTH_A23_SLIB) \
	$(BIDI_MESSAGE_QUEUE_DRV_UTH_SLIB) 
	if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(LD) $(LDFLAGS) -o $@ \
		-T $(SOCBLOX)/esw/a23_boot/a23_baremetal.lds $^ \
		$(LIBC) $(LIBGCC)
	
	# $(LIBCPP)	
#		-T $(SOCBLOX)/esw/a23_boot/a23_baremetal.lds $^ 

baremetal/%.o : %.cpp
	if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(CXX) -o $@ -c $(CXXFLAGS) $^ 
	
#	$(SVF_OBJDIR)/a23_dualcore_low_level_init.o \
	$(SVF_OBJDIR)/a23_cpp_support.o \
	$(SVF_OBJDIR)/a23_memory.o 
	
uex/%.elf : uex/%.o \
	$(SVF_OBJDIR)/a23_uex_boot.o 
	if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(LD) $(LDFLAGS) -o $@ \
		-T $(SOCBLOX)/esw/a23_uex_hal/a23_uex_hal.lds $^ \
		$(LIBCPP) $(LIBC) $(LIBGCC)
	
#uex/%.o : %.cpp
#	if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
#	$(CXX) -o $@ -c $(CXXFLAGS) $^ 

endif
