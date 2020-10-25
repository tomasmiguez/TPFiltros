ReforzarBrillo_c:
    push    r15
    lea     eax, [r8+6]
    push    r14
    mov     r14, rdi
    mov     edi, ecx
    push    r13
    push    r12
    push    rbp
    push    rbx
    sub     rsp, 56
    add     r8d, 3
    cmovs   r8d, eax
    mov     DWORD PTR [rsp+20], ecx
    lea     ecx, [r9+6]
    mov     ebx, DWORD PTR [rsp+112]
    mov     ebp, DWORD PTR [rsp+128]
    mov     r13d, DWORD PTR [rsp+136]
    sar     r8d, 2
    add     r9d, 3
    cmovns  ecx, r9d
    sar     ecx, 2
    test    edi, edi
    jle     .L1
    test    edx, edx
    jle     .L1
    movsx   rcx, ecx
    movsx   rax, r8d
    mov     QWORD PTR [rsp+8], r14
    sal     rcx, 2
    sal     rax, 2
    mov     DWORD PTR [rsp+16], 0
    mov     QWORD PTR [rsp+32], rcx
    lea     ecx, [rdx-1]
    mov     edx, edx
    neg     rdx
    mov     QWORD PTR [rsp+24], rax
    lea     r15, [rsi+4+rcx*4]
    lea     rax, [0+rdx*4]
    mov     r14, r15
    mov     QWORD PTR [rsp+40], rax
.L4:
    mov     rax, QWORD PTR [rsp+40]
    mov     r15, QWORD PTR [rsp+8]
    lea     r12, [rax+r14]
    jmp     .L8
.L5:
    cmp     eax, DWORD PTR [rsp+120]
    jl      .L13
    mov     BYTE PTR [r12], dil
    mov     BYTE PTR [r12+1], r9b
    mov     BYTE PTR [r12+2], cl
.L6:
    add     r12, 4
    add     r15, 4
    cmp     r14, r12
    je      .L14
.L8:
    movzx   eax, BYTE PTR [r15+2]
    movzx   r9d, BYTE PTR [r15+1]
    movzx   edi, BYTE PTR [r15]
    mov     ecx, eax
    lea     eax, [rax+r9*2]
    add     eax, edi
    sar     eax, 2
    cmp     eax, ebx
    jle     .L5
    add     edi, ebp
    add     r12, 4
    add     r15, 4
    call    utils_saturate
    mov     BYTE PTR [r12-4], al
    movzx   edi, BYTE PTR [r15-3]
    add     edi, ebp
    call    utils_saturate
    mov     BYTE PTR [r12-3], al
    movzx   edi, BYTE PTR [r15-2]
    add     edi, ebp
    call    utils_saturate
    mov     BYTE PTR [r12-2], al
    cmp     r14, r12
    jne     .L8
.L14:
    add     DWORD PTR [rsp+16], 1
    mov     rsi, QWORD PTR [rsp+24]
    mov     eax, DWORD PTR [rsp+16]
    add     QWORD PTR [rsp+8], rsi
    add     r14, QWORD PTR [rsp+32]
    cmp     DWORD PTR [rsp+20], eax
    jne     .L4
.L1:
    add     rsp, 56
    pop     rbx
    pop     rbp
    pop     r12
    pop     r13
    pop     r14
    pop     r15
    ret
.L13:
    sub     edi, r13d
    call    utils_saturate
    mov     BYTE PTR [r12], al
    movzx   edi, BYTE PTR [r15+1]
    sub     edi, r13d
    call    utils_saturate
    mov     BYTE PTR [r12+1], al
    movzx   edi, BYTE PTR [r15+2]
    sub     edi, r13d
    call    utils_saturate
    mov     BYTE PTR [r12+2], al
    jmp     .L6