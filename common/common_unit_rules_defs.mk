
ifneq (1,$(RULES))

SRC_DIRS := $(SRC_DIRS) $($(UNIT_NAME)_DIR)
# SRC_DIRS += $($(UNIT_NAME)_DIR)
	
$(UNIT_NAME)_OBJS :=$(foreach o,$($(UNIT_NAME)_SRC:.cpp=.o),$(SOCBLOX_OBJDIR)/$(o))
$(UNIT_NAME)_LIB :=$(SOCBLOX_LIBDIR)/lib$(LIB_NAME)$(DLLEXT)

LIB_TARGETS := $(LIB_TARGETS) $(SOCBLOX_LIBDIR)/lib$(LIB_NAME)$(DLLEXT)

$(UNIT_NAME)_LINK := -L$(SVF_LIBDIR) -l$(LIB_NAME)

else

$($(UNIT_NAME)_LIB) : $($(UNIT_NAME)_OBJS) $(LIBSVF)

endif
