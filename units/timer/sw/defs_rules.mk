
TIMER_SW_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

ifneq (1,$(RULES))

SRC_DIRS += $(TIMER_SW_DIR)

LIB_TARGETS += $(SVF_LIBDIR)/libtimer.a

TIMER_SRC = timer_drv.cpp

else

$(SVF_LIBDIR)/libtimer.a : $(foreach o,$(TIMER_SRC:.cpp=.o),$(SVF_OBJDIR)/$(o))

endif