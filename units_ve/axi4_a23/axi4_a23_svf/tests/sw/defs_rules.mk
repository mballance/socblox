
TESTS_SW_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

ifneq (1,$(RULES))

A23_CORE_TESTS=\
	adc \
	add \
	addr_ex \
	\
	barrel_shift_rs \
	barrel_shift \
	\
	bcc \
	bic_bug \
	bl \
	\
	cache_flush \
	cache_swap_bug \
	cache_swap \
	\
	cache1 \
	cache2 \
	cache3 \
	\
	cacheable_area \
	\
	change_mode \
	\
	ldm1 \
	ldm2 \
	ldm3 \
	ldm4 \
	ldr \
	\
	swp
	
EXTS=.elf .dis 

EXE_TARGETS += $(foreach e, $(EXTS), $(foreach t, $(A23_CORE_TESTS), core_tests/$(t)$(e)))

SRC_DIRS += $(TESTS_SW_DIR) 

else

#%.o : %
#	if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
#	$(CC) -c $^ -o $@
	
#$(SVF_OBJDIR)/%.o : %
#	if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
#	$(CC) -c $^ -o $@
	
$(SVF_OBJDIR)/%.o : %.c
	if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(CC) -c $(CFLAGS) $^ -o $@

%.mem : %.elf
	$(OBJCOPY) $^ -O verilog $@
#	perl `which objcopy_verilog_filter.pl` $@

%.hex : %.elf
	$(OBJCOPY) $^ -O ihex $@
	
%.dis : %.elf
	$(OBJDUMP) --disassemble -S $^ > $@
	
%.dat : %.hex
	perl $(SOCBLOX)/common/scripts/objcopy_ihex2quartus_filter.pl \
		$^ $@
	
core_tests/%.elf : core_tests/%.o 
	if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(LD) $(LDFLAGS) -o $@ \
		-T $(TESTS_SW_DIR)/sections.lds $^
		
core_tests/%.o : %.S
	if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(CC) -o $@ -c $(CFLAGS) $^ 

endif
