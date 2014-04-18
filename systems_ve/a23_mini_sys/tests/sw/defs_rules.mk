
TESTS_SW_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(SOCBLOX)/units/wb_uart/sw/defs_rules.mk

ifneq (1,$(RULES))

SRC_DIRS += $(TESTS_SW_DIR)

EXE_TARGETS += smoke.mem smoke.hex smoke.elf smoke.dat

%.mem : %.elf
	$(OBJCOPY) $^ -O verilog $@
#	perl `which objcopy_verilog_filter.pl` $@

%.hex : %.elf
	$(OBJCOPY) $^ -O ihex $@
	
%.dat : %.hex
	perl $(SOCBLOX)/common/scripts/objcopy_ihex2quartus_filter.pl \
		$^ $@

%.o : %.S
	$(CC) -c $^ 

%.elf : %.o
	$(LD) $(LDFLAGS) -o $@ \
		-T $(SOCBLOX)/esw/a23_boot/a23_baremetal.lds $^
	
else

endif
