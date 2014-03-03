
ifeq (,$(RULES))

TESTS_SW_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

SW_CORE_TESTS_SRC = \
	add.S
	
SW_BAREMETAL_TESTS_SRC = \
	file1.cpp
	

SW_CORE_TESTS=$(foreach e,$(SW_CORE_TESTS_SRC:.S=.elf),$(BUILD_DIR)/core_tests/$(e))
SW_BAREMETAL_TESTS=$(foreach e,$(SW_BAREMETAL_TESTS_SRC:.cpp=.elf),$(BUILD_DIR)/baremetal_tests/$(e))

TARGET_EXE_TARGETS += $(SW_CORE_TESTS) $(SW_BAREMETAL_TESTS)

SRC_DIRS += $(TESTS_SW_DIR) $(TESTS_SW_DIR)/baremetal
SRC_DIRS += $(SOCBLOX)/esw/a23_boot $(SOCBLOX)/systems/a23_dualcore/sw

else
# $(BUILD_DIR)/target_objs/%.o
$(BUILD_DIR)/core_tests/%.elf : $(BUILD_DIR)/target_objs/%.o
	if test ! -d $(BUILD_DIR)/core_tests; then mkdir -p $(BUILD_DIR)/core_tests; fi
	$(TARGET_LD) $(TARGET_LDFLAGS) -o $@ \
		-T $(SIM_DIR)/../tests/sw/sections.lds $^
		
$(BUILD_DIR)/baremetal_tests/%.elf : \
		$(BUILD_DIR)/target_objs/%.o \
		$(BUILD_DIR)/target_objs/a23_startup.o \
		$(BUILD_DIR)/target_objs/a23_dualcore_low_level_init.o
	if test ! -d $(BUILD_DIR)/baremetal_tests; then mkdir -p $(BUILD_DIR)/baremetal_tests; fi
	$(TARGET_LD) $(TARGET_LDFLAGS) -o $@ \
		-T $(SOCBLOX)/esw/a23_boot/a23_baremetal.lds $^ \
		$(A23_LIBGCC)

endif
