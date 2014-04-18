

void low_level_init()
{
	// TODO: enable memory controllers

	// Enable cache for code/data
	// 31:27
	// Page 0 - 0x00000000-0x07FFFFFFF
	// Page 4 - 0x20000000-0x27FFFFFFF
	asm(
//			"mov	r0, #0x00000011\n"
			"mov	r0, #0x00000011\n"
			"mcr	15, 0, r0, cr3, cr0, 0\n"
			"mov	r0, #1\n"
			"mcr	15, 0, r0, cr2, cr0, 0\n"); // Enable cache

	// TODO: setup timer interrupt

}
