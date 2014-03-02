
ifeq (,$(RULES))

else

$(BUILD_DIR)/target_objs/%.o : %.S
	if test ! -d $(BUILD_DIR)/target_objs; then mkdir -p $(BUILD_DIR)/target_objs; fi
	$(TARGET_CC) -c $(TARGET_CFLAGS) $^ -o $@
	
$(BUILD_DIR)/target_objs/%.o : %.cpp
	if test ! -d $(BUILD_DIR)/target_objs; then mkdir -p $(BUILD_DIR)/target_objs; fi
	$(TARGET_CXX) -c $(TARGET_CXXFLAGS) $^ -o $@
	
$(BUILD_DIR)/target_objs/%.o : %.c
	if test ! -d $(BUILD_DIR)/target_objs; then mkdir -p $(BUILD_DIR)/target_objs; fi
	$(TARGET_CC) -c $(TARGET_CFLAGS) $^ -o $@

endif
	