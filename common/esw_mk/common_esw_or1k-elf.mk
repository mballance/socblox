
ifneq (1,$(RULES))
CC=$(TARGET)-gcc
CXX=$(TARGET)-g++
LD=$(TARGET)-ld
AS=$(CC)
OBJDUMP=$(TARGET)-objdump
OBJCOPY=$(TARGET)-objcopy

LIBGCC:=$(shell $(CC) -print-libgcc-file-name)
LIBC:=$(dir $(LIBGCC))/../../../../$(TARGET)/lib/libc.a
LIBCXX:=$(dir $(LIBGCC))/../../../../$(TARGET)/lib/libstdc++.a
else

endif
