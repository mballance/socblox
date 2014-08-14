
DEVICE ?= cyclonev
ROM_FILE ?= rom.hex
# MEM_FILE ?= rom.dat

.phony: all sim target_build

all :
	echo "Error: specify target of sim or img"
	exit 1
	
include $(COMMON_DIR)/synth_mk/synth_mk_$(DEVICE).mk

vpath %.f $(SRC_DIRS)
vpath %.sdc $(SRC_DIRS)
vpath %.dat $(SRC_DIRS)


target_build :
	if test "x$(TARGET_MAKEFILE)" != "x"; then \
		$(MAKE) -f $(TARGET_MAKEFILE) build; \
	fi

RULES := 1

include $(COMMON_DIR)/synth_mk/synth_mk_$(DEVICE).mk
