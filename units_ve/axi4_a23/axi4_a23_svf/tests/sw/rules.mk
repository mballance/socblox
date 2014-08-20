

$(SVF_OBJDIR)/core_tests/%.elf : $(SVF_OBJDIR)/core_tests/%.o
	arm-none-eabi-ld $(LDFLAGS) -o $(SVF_OBJDIR)/core_tests/$*.elf \
		-T $(A23_CORE_TESTS_DIR)/sections.lds $(SVF_OBJDIR)/core_tests/$*.o

$(SVF_OBJDIR)/core_tests/%.o : $(A23_CORE_TESTS_DIR)/%.S
	if test ! -d $(SVF_OBJDIR)/core_tests; then mkdir -p $(SVF_OBJDIR)/core_tests; fi
	arm-none-eabi-gcc -c $(A23_CFLAGS) -o $(SVF_OBJDIR)/core_tests/$*.o $(A23_CORE_TESTS_DIR)/$*.S

$(SVF_OBJDIR)/core_tests/%.dis : $(SVF_OBJDIR)/core_tests/%.elf
	arm-none-eabi-objdump --disassemble -S $^ > $@
	