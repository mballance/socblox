
TESTS_SW_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(SOCBLOX)/units/wb_uart/sw/defs_rules.mk

ifneq (1,$(RULES))

SRC_DIRS += $(TESTS_SW_DIR) $(TESTS_SW_DIR)/baremetal
SRC_DIRS += $(TESTS_SW_DIR)/svf $(TESTS_SW_DIR)/svf/env
SRC_DIRS += $(TESTS_SW_DIR)/svf/tests

# EXE_TARGETS += smoke.mem smoke.hex smoke.elf smoke.dat

BAREMETAL_TESTS_1 := smoke thread_primitives msg_queue_smoke \
  uth_yield_test uth_thread_swap_test svf_smoketest memmove_test \
  memaccess_test sprintf_test dual_core_start_smoke \
  single_core_start_smoke
  
BAREMETAL_TESTS := dual_core_start_smoke single_core_start_smoke \
	dual_core_nocache_reset_smoke dual_core_cache_reset_smoke \
	dual_core_cache_producer_consumer_smoke
	
SVF_TESTS := svf_basics
SVF_ENV_SRCS := $(notdir $(wildcard $(TESTS_SW_DIR)/svf/env/*.cpp))
SVF_ENV_OBJS := $(SVF_ENV_SRCS:.cpp=.o)
SVF_TESTS_SRCS := $(notdir $(wildcard $(TESTS_SW_DIR)/svf/tests/*.cpp))
SVF_TESTS_OBJS := $(SVF_TESTS_SRCS:.cpp=.o)

# UEX_TESTS := uex_simple_thread
EXTS=.bin .mem .hex .elf .dat

EXE_TARGETS += $(foreach e, $(EXTS), $(foreach t, $(BAREMETAL_TESTS), baremetal/$(t)$(e)))
EXE_TARGETS += $(foreach e, $(EXTS), $(foreach t, $(UEX_TESTS), uex/$(t)$(e)))
EXE_TARGETS += $(foreach e, $(EXTS), $(foreach t, $(SVF_TESTS), svf/$(t)$(e)))

EXE_TARGETS += preloader/a23_preloader.mem
EXE_TARGETS += preloader/a23_preloader.elf
# EXE_TARGETS += preloader/a23_preloader.o
# EXE_TARGETS += a23_preloader.o
# EXE_TARGETS += print
# EXE_TARGETS += preloader/a23_preloader.elf
# EXE_TARGETS += svf/svf_basics.o

vpath %.elf preloader

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
	
preloader/%.mem : preloader/%.elf
	$(OBJCOPY) $^ -O verilog $@

%.bin : %.elf
	$(OBJCOPY) $^ -O binary $@

%.hex : %.elf
	$(OBJCOPY) $^ -O ihex $@
	
%.dat : %.hex
	perl $(SOCBLOX)/common/scripts/objcopy_ihex2quartus_filter.pl \
		$^ $@

baremetal/%.elf : baremetal/%.o \
	$(SVF_OBJDIR)/a23_startup_multicore.o \
	$(SVF_OBJDIR)/io_stubs.o \
	$(SVF_OBJDIR)/uex_thread_primitives.o \
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
		-T $(SOCBLOX)/esw/a23_boot/a23_baremetal_multicore.lds $^ \
		$(LIBC) $(LIBGCC)
	
baremetal/%.o : %.cpp
	if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(CXX) -o $@ -c $(CXXFLAGS) $^ 
	
preloader/%.o : %.cpp
	if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(CXX) -o $@ -c $(CXXFLAGS) $^ 
	
uex/%.elf : uex/%.o \
	$(SVF_OBJDIR)/a23_uex_boot.o 
	if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(LD) $(LDFLAGS) -o $@ \
		-T $(SOCBLOX)/esw/a23_uex_hal/a23_uex_hal.lds $^ \
		$(LIBCPP) $(LIBC) $(LIBGCC)
		
		
svf/%.elf : svf/%.o \
	$(SVF_OBJDIR)/a23_preloader_app_crt0.o \
	$(foreach o,$(SVF_ENV_OBJS),svf/env/$o) \
	$(foreach o,$(SVF_TESTS_OBJS),svf/tests/$o) \
	$(SVF_OBJDIR)/io_stubs.o \
	$(SVF_OBJDIR)/uex_thread_primitives.o \
	$(SVF_OBJDIR)/a23_cpp_support.o \
	$(SVF_OBJDIR)/a23_memory.o \
	$(SVF_LIBDIR)/libbidi_message_queue_drv.a \
	$(SVF_LIBDIR)/libbidi_message_queue_drv_uth.a \
	$(LIBSVF_UTH_AR) \
	$(UTH_COOP_THREAD_MGR_SLIB) \
	$(UTH_SLIB) \
	$(UTH_A23_SLIB)
	if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(LD) $(LDFLAGS) -o $@ $^ \
		-T $(SYSTEMS)/a23_dualcore_sys/sw/preloader_app/a23_preloader_app.lds \
		$(LIBC) $(LIBGCC) $(LIBCXX)
	
	
#uex/%.o : %.cpp
#	if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
#	$(CXX) -o $@ -c $(CXXFLAGS) $^ 

endif
