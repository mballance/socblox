
ifeq (,$(RULES))

else

$(BUILD_DIR)/target_objs/%.o : %.S
	if test ! -d $(BUILD_DIR)/target_objs; then mkdir -p $(BUILD_DIR)/target_objs; fi
	$(TARGET_CC) -c $(TARGET_CFLAGS) $^ -o $@

endif
	