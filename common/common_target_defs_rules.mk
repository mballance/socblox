
ifneq (1,$(RULES))

else

$(BUILD_DIR)/target_objs/%.o : %.S
	if test ! -d $(BUILD_DIR)/target_objs; then mkdir -p $(BUILD_DIR)/target_objs; fi
	$(CC) -c $(CFLAGS) $^ -o $@
	
$(BUILD_DIR)/target_objs/%.o : %.cpp
	if test ! -d $(BUILD_DIR)/target_objs; then mkdir -p $(BUILD_DIR)/target_objs; fi
	$(CXX) -c $(CXXFLAGS) $^ -o $@
	
$(BUILD_DIR)/target_objs/%.o : %.c
	if test ! -d $(BUILD_DIR)/target_objs; then mkdir -p $(BUILD_DIR)/target_objs; fi
	$(CC) -c $(CFLAGS) $^ -o $@

endif
	