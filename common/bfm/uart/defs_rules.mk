
UART_BFM_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

ifeq (,$(RULES))

CXXFLAGS += -I$(UART_BFM_DIR)

UART_BFM_SRC = \
	uart_bfm.cpp \
	uart_bfm_dpi_mgr.cpp
	
UART_BFM_OBJS=$(foreach o,$(UART_BFM_SRC:.cpp=.o),$(SOCBLOX_OBJDIR)/$(o))
	
UART_BFM_LIB=$(SOCBLOX_LIBDIR)/libuart_bfm$(DLLEXT)

LIB_TARGETS += $(UART_BFM_LIB)

UART_BFM_LINK=-L$(SOCBLOX_LIBDIR) -luart_bfm

SRC_DIRS += $(UART_BFM_DIR)

else

$(UART_BFM_LIB) : $(UART_BFM_OBJS) $(LIBSVF)
	if test -d $(SOCBLOX_LIBDIR); then mkdir -p $(SOCBLOX_LIBDIR); fi
	$(LINK) -o $@ $(DLLOUT) $(UART_BFM_OBJS) $(LIBSVF_LINK)
	
$(SOCBLOX_OBJDIR)/%.o : $(UART_BFM_DIR)/%.cpp
	if test ! -d $(SOCBLOX_OBJDIR); then mkdir -p $(SOCBLOX_OBJDIR); fi
	$(CXX) -c -o $@ $(CXXFLAGS) $^



endif