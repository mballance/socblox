
ifeq (,$(RULES))

A23_CROSSTOOL = arm-none-eabi
A23_CC  = $(A23_CROSSTOOL)-gcc
A23_AS  = $(A23_CC)
A23_CXX = $(A23_CROSSTOOL)-g++
A23_AR  = $(A23_CROSSTOOL)-ar
A23_LD  = $(A23_CROSSTOOL)-ld
A23_DS  = $(A23_CROSSTOOL)-objdump
A23_OC  = $(A23_CROSSTOOL)-objcopy
A23_STR = $(A23_CROSSTOOL)-strip

A23_CFLAGS += -Os -march=armv2a -mno-thumb-interwork -ffreestanding
A23_LDFLAGS += -Bstatic --fix-v4bx
A23_LIBGCC:=$(shell $(A23_CC) -mno-thumb-interwork -print-libgcc-file-name)

else

endif
