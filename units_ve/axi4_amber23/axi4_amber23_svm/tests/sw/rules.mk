

$(BUILD_DIR)/core_tests/%.elf : $(BUILD_DIR)/core_tests/%.o
	arm-none-eabi-ld $(LDFLAGS) -o $(BUILD_DIR)/core_tests/$*.elf \
		-T $(A23_CORE_TESTS_DIR)/sections.lds $(BUILD_DIR)/core_tests/$*.o

$(BUILD_DIR)/core_tests/%.o : $(A23_CORE_TESTS_DIR)/%.S
	if test ! -d $(BUILD_DIR)/core_tests; then mkdir -p $(BUILD_DIR)/core_tests; fi
	arm-none-eabi-gcc -c $(A23_CFLAGS) -o $(BUILD_DIR)/core_tests/$*.o $(A23_CORE_TESTS_DIR)/$*.S

	