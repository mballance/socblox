OUTPUT_FORMAT("elf32-littlearm", "elf32-bitarm", "elf32-littlearm")
OUTPUT_ARCH(arm)
ENTRY(_start)

MEMORY {
	RAM(rwx)	: ORIGIN = 0x0c100000, LENGTH = 256M
}

SECTIONS {
	.reset : {
		*ub_crt0.o (.text)
		. = ALIGN(0x10);
	} > RAM

	. = ALIGN(0x10);

	.text : {
                CREATE_OBJECT_SYMBOLS
                *(.text .text.* .gnu.linkonce.t.*)
                *(.plt)
                *(.gnu.warning)
                *(.glue_7t) *(.glue_7)

                . = ALIGN(0x10);

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
	} > RAM

	. = ALIGN(0x10);

        .init_array : {
                __init_array_start = .;
                _init = .;
                *(.init_array)
        } >RAM
        __init_array_end = .;

        .ARM.exidx : {
                __exidx_start = .;
                *(.ARM.exidx* .gnu.linkonce.armexidx.*)
                __exidx_end = .;
        } >RAM
        _etext = .;

        . = ALIGN(0x10);

        .data : {
                __data_load = LOADADDR(.data);
                __data_start = .;
                KEEP(*(.jcr))
                *(.got.plt) *(.got)
                *(.shdata)
                *(.data .data.* .gnu.linkonce.d.*)
                . = ALIGN(0x10);
                _edata = .;
        } >RAM

        . = ALIGN(0x10);

        .bss : {
                __bss_start = .;
                *(.shbss)
                *(.bss .bss.* .gnu.linkonce.b.*)
                *(COMMON)
                . = ALIGN(0x10);
                __bss_end = .;
        } >RAM

        . = ALIGN(0x10);

	__heap_start = .;

        . = ALIGN(0x10);

	_end = .;
        PROVIDE(end = .);

        .stab 0 (NOLOAD) : {
                *(.stab)
        }

        .stabstr 0 (NOLOAD) : {
                *(.stabstr)
        }

        .debug                  0 : { *(.debug) }
        .line                   0 : { *(.line) }

}

