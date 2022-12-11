; nasm -f elf64 day3_2.asm -o day3.o; gcc -static -o day3 day3.o
BITS 64
SECTION .data
    strFormat: db "%s", 0
    intFormat: db "%d", 0
SECTION .bss
    buf: resb 4096
    leftCnt: resq 256
    midCnt: resq 256
    rightCnt: resq 256
SECTION .text
    GLOBAL main
    extern printf
    extern scanf

main:
    push rbx
    push r12
    push rbp
    mov rbp, rsp
    xor r12, r12
    
    .testcaseLoopBegin:
    
    xor rcx, rcx
    .clearCnts:
    mov qword [leftCnt+rcx*8], 0
    mov qword [midCnt+rcx*8], 0
    mov qword [rightCnt+rcx*8], 0
    inc rcx
    cmp rcx, 256
    jne .clearCnts

    ; Handle single line of input (0 mod 3)
    mov rdi, strFormat
    mov rsi, buf
    call scanf wrt ..plt

    xor rcx, rcx
    .getLen0:
    inc rcx
    cmp byte [buf+rcx], 0
    jne .getLen0

    xor rsi, rsi 
    .update0:
    xor rdx, rdx
    mov dl, [buf+rsi]
    inc qword [leftCnt+rdx*8]

    inc rsi
    cmp rsi, rcx
    jne .update0


    ; Handle single line of input (1 mod 3)
    mov rdi, strFormat
    mov rsi, buf
    call scanf wrt ..plt


    xor rcx, rcx
    .getLen1:
    inc rcx
    cmp byte [buf+rcx], 0
    jne .getLen1

    xor rsi, rsi 
    .update1:
    xor rdx, rdx
    mov dl, [buf+rsi]
    inc qword [midCnt+rdx*8]

    inc rsi
    cmp rsi, rcx
    jne .update1


    ; Handle single line of input (2 mod 3)
    mov rdi, strFormat
    mov rsi, buf
    call scanf wrt ..plt

    cmp rax, 1
    jne .printAnswer

    xor rcx, rcx
    .getLen2:
    inc rcx
    cmp byte [buf+rcx], 0
    jne .getLen2

    xor rsi, rsi 
    .update2:
    xor rdx, rdx
    mov dl, [buf+rsi]
    inc qword [rightCnt+rdx*8]

    inc rsi
    cmp rsi, rcx
    jne .update2

    
    mov rcx, 97
    .scanThroughLowercase:
    cmp qword [leftCnt+rcx*8], 0
    je .scanLIterationFail
    cmp qword [midCnt+rcx*8], 0
    je .scanLIterationFail
    cmp qword [rightCnt+rcx*8], 0
    je .scanLIterationFail
    add r12, rcx
    sub r12, 96
    
    .scanLIterationFail:
    inc rcx
    cmp rcx, 123
    jne .scanThroughLowercase


    mov rcx, 65
    .scanThroughUppercase:
    cmp qword [leftCnt+rcx*8], 0
    je .scanUIterationFail
    cmp qword [midCnt+rcx*8], 0
    je .scanUIterationFail
    cmp qword [rightCnt+rcx*8], 0
    je .scanUIterationFail
    add r12, rcx
    sub r12, 64
    add r12, 26
    
    .scanUIterationFail:
    inc rcx
    cmp rcx, 91
    jne .scanThroughUppercase


    jmp .testcaseLoopBegin


    .printAnswer:
    
    mov rdi, intFormat
    mov rsi, r12
    call printf

    xor rax, rax
    mov rsp, rbp
    pop rbp
    pop r12
    pop rbx
    ret
