
COMMON_SIM_TARGET_MK := $(lastword $(MAKEFILE_LIST))
COMMON_SIM_TARGET_MK_DIR := $(dir $(COMMON_SIM_TARGET_MK))

CC=$(TARGET)-gcc
CXX=$(TARGET)-g++
LD=$(TARGET)-ld
AS=$(CC)
OBJDUMP=$(TARGET)-objdump
OBJCOPY=$(TARGET)-objcopy

LIBGCC:=$(shell $(CC) -mno-thumb-interwork -print-libgcc-file-name)
LIBC:=$(dir $(LIBGCC))/../../../../$(TARGET)/lib/libc.a


# include $(COMMON_SIM_MK_DIR)/common_defs.mk
include $(MK_INCLUDES)

CXXFLAGS += $(foreach dir, $(SRC_DIRS), -I$(dir))

LIB_TARGETS += $(BFM_LIBS)

vpath %.cpp $(SRC_DIRS)
vpath %.S $(SRC_DIRS)
vpath %.c $(SRC_DIRS)

.phony: all build 

all :
	echo "Error: Specify target of build or run
	exit 1

build : $(LIB_TARGETS) $(EXE_TARGETS)


RULES := 1
# include $(COMMON_SIM_MK_DIR)/common_rules.mk
include $(MK_INCLUDES)

$(SVF_OBJDIR)/%.o : %.cpp
	if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(CXX) -c -o $@ $(CXXFLAGS) $^
	
$(SVF_LIBDIR)/%.a : 
	if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	rm -f $@
	ar vcq $@ $^
	
$(SVF_LIBDIR)/sc/%.so : 
	if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(LINK) -shared -o $@ $^
	
$(SVF_LIBDIR)/dpi/%.so : 
	if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(LINK) -shared -o $@ $^
	
$(SVF_LIBDIR)/sc_qs/%.so : 
	if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(LINK) -shared -o $@ $^

%.o : %.cpp
	if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(CXX) -c -o $@ $(CXXFLAGS) $^	
	
%.o : %.C
	if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(AS) -c -o $@ $(ASFLAGS) $^	
	