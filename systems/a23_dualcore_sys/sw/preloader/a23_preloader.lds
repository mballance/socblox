OUTPUT_FORMAT("elf32-littlearm", "elf32-bitarm", "elf32-littlearm")
OUTPUT_ARCH(arm)
ENTRY(_start)

MEMORY {
	ROM(rx)		: ORIGIN = 0x00000000, LENGTH = 64K
	RAM(rwx)	: ORIGIN = 0x02000000, LENGTH = 64K
}

C_STACK_SIZE = 4096;
IRQ_STACK_SIZE = 128;
FIQ_STACK_SIZE = 128;
SVC_STACK_SIZE = 128;
ABT_STACK_SIZE = 128;
UND_STACK_SIZE = 128;
MBOX_SIZE = 16;

SECTIONS {
	.reset : {
		*a23_preloader_crt0.o (.text)
		. = ALIGN(0x4);
	} > ROM
	
	.ramvect : {
		__ram_start = .;
		. = 0x40;
	} > RAM
	
	.text : {
		CREATE_OBJECT_SYMBOLS
		*(.text .text.* .gnu.linkonce.t.*)
		*(.plt)
		*(.gnu.warning)
		*(.glue_7t) *(.glue_7)
		
		. = ALIGN(0x4);
		
		/* Static constructor / destructors */
		KEEP (*crtbegin.o(.ctors))
		KEEP (*(EXCLUDE_FILE (*crtend.o) .ctors))
		KEEP (*(SORT(.ctors.*)))
		KEEP (*crtend.o(.ctors))
		KEEP (*crtbegin.o(.dtors))
		KEEP (*(EXCLUDE_FILE (*crtend.o) .dtors))
		KEEP (*(SORT(.dtors.*)))
		KEEP (*crtend.o(.dtors))
	
		*(.rodata .rodata.* .gnu.linkonce.r.*)
		
		*(.init)
		*(.fini)
	} >ROM

	.init_array : {
		__init_array_start = .;	
		_init = .;
		*(.init_array)
	} >ROM
	__init_array_end = .;
	
	.ARM.exidx : {
		__exidx_start = .;
		*(.ARM.exidx* .gnu.linkonce.armexidx.*)
		__exidx_end = .;
	} >ROM
	_etext = .;
	
	.data : {
		__data_load = LOADADDR(.data);
		__data_start = .;
		KEEP(*(.jcr))
		*(.got.plt) *(.got)
		*(.shdata)
		*(.data .data.* .gnu.linkonce.d.*)
		. = ALIGN(4);
		_edata = .;
	} >RAM AT>ROM
	
	.bss : {
		__bss_start__ = .;
		*(.shbss)
		*(.bss .bss.* .gnu.linkonce.b.*)
		*(COMMON)
		. = ALIGN(4);
		__bss_end__ = .;
	} >RAM
	
	.start : {
		/* Reserve space for a pointer to the coreinfo block */
		PROVIDE(coreinfo = .);
		. += 16;
		
		__heap_start = .;
		. += 32k;
		. = ALIGN(4);
		__heap_end = .;
		
		__stack_start__ = . ;
		. += 8k;
		. = ALIGN(4);
		__stack_end__ = . ;
	} >RAM

	.stab 0 (NOLOAD) : {
		*(.stab)
	}
	
	.stabstr 0 (NOLOAD) : {
		*(.stabstr)
	}
	
	.debug			0 : { *(.debug) }
	.line			0 : { *(.line) }
}
	
