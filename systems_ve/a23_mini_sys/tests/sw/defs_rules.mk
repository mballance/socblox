
TESTS_SW_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(SOCBLOX)/units/wb_uart/sw/defs_rules.mk

ifneq (1,$(RULES))

SRC_DIRS += $(TESTS_SW_DIR) $(TESTS_SW_DIR)/baremetal

# EXE_TARGETS += smoke.mem smoke.hex smoke.elf smoke.dat

BAREMETAL_TESTS := smoke
EXTS=.mem .hex .elf .dat

EXE_TARGETS += $(foreach e, $(EXTS), $(foreach t, $(BAREMETAL_TESTS), baremetal/$(t)$(e)))



#%.o : %.S
#	$(CC) -c $^ 

#%.elf : %.o
#	$(LD) $(LDFLAGS) -o $@ \
#		-T $(SOCBLOX)/esw/a23_boot/a23_baremetal.lds $^
		
	
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

%.hex : %.elf
	$(OBJCOPY) $^ -O ihex $@
	
%.dat : %.hex
	perl $(SOCBLOX)/common/scripts/objcopy_ihex2quartus_filter.pl \
		$^ $@
	
A=	\

baremetal/%.elf : baremetal/%.o \
	$(SVF_OBJDIR)/a23_startup.o \
	$(SVF_OBJDIR)/a23_minisys_low_level_init.o \
	$(SVF_OBJDIR)/a23_cpp_support.o \
	$(SVF_OBJDIR)/a23_memory.o \
	$(SVF_LIBDIR)/libtimer.a   \
	$(SVF_LIBDIR)/libintc.a   
	if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(LD) $(LDFLAGS) -o $@ \
		-T $(SOCBLOX)/esw/a23_boot/a23_baremetal.lds $^ \
		$(LIBC) $(LIBGCC)
		
baremetal/%.o : %.cpp
	if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(CXX) -o $@ -c $(CXXFLAGS) $^ 

endif
