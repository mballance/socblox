
UNIT_NAME := WB_UART_DRIVER
LIB_NAME := wb_uart_driver
$(UNIT_NAME)_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

ifeq (,$(RULES))

$(UNIT_NAME)_SRC := \
	wb_uart_driver.cpp

else

endif