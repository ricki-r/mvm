	.file	"kernel.c"
	.text
	.globl	@kernel_entry@4
	.def	@kernel_entry@4;	.scl	2;	.type	32;	.endef
@kernel_entry@4:
LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$20, %esp
	movl	%ecx, -20(%ebp)
	movl	$0, -4(%ebp)
	addl	$1, -4(%ebp)
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE0:
	.ident	"GCC: (MinGW-W64 x86_64-posix-seh, built by Brecht Sanders) 10.2.0"
