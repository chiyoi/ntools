.global _main

.data

.text
_main:
    movl $0x02000001, %eax
    movb $0x00, %dil
    syscall

