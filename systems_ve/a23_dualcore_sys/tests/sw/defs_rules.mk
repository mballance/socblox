
ifeq (,$(RULES))

TESTS_SW_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

SW_CORE_TESTS_SRC = \
	add.S

SW_CORE_TESTS=$(foreach e,$(SW_CORE_TESTS_SRC:.S=.elf),$(BUILD_DIR)/core_tests/$(e))

TARGET_EXE_TARGETS += $(SW_CORE_TESTS)

SRC_DIRS += $(TESTS_SW_DIR)

else
# $(BUILD_DIR)/target_objs/%.o
$(BUILD_DIR)/core_tests/%.elf : $(BUILD_DIR)/target_objs/%.o
	if test ! -d $(BUILD_DIR)/core_tests; then mkdir -p $(BUILD_DIR)/core_tests; fi
	$(TARGET_LD) $(TARGET_LDFLAGS) -o $@ \
		-T $(SIM_DIR)/../tests/sw/sections.lds $^

endif
