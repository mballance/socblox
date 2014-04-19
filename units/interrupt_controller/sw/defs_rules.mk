
INTC_SW_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

ifneq (1,$(RULES))

SRC_DIRS += $(INTC_SW_DIR)

LIB_TARGETS += $(SVF_LIBDIR)/libintc.a

INTC_SRC = intc_drv.cpp

else

$(SVF_LIBDIR)/libintc.a : $(foreach o,$(INTC_SRC:.cpp=.o),$(SVF_OBJDIR)/$(o))

endif