ImagenFantasma_c:
        push    r15
        lea     eax, [r8+6]
        push    r14
        push    r13
        push    r12
        push    rbp
        push    rbx
        sub     rsp, 56
        add     r8d, 3
        cmovs   r8d, eax
        lea     eax, [r9+6]
        mov     DWORD PTR [rsp+36], ecx
        sar     r8d, 2
        add     r9d, 3
        cmovs   r9d, eax
        sar     r9d, 2
        test    ecx, ecx
        jle     .L1
        test    edx, edx
        jle     .L1
        movsx   r8, r8d
        movsx   r9, r9d
        mov     r12, rdi
        mov     rbx, rsi
        lea     rax, [0+r8*4]
        mov     DWORD PTR [rsp+32], 0
        mov     r15, rdi
        lea     r14d, [rdx-1]
        mov     QWORD PTR [rsp+24], rax
        lea     rax, [0+r9*4]
        mov     QWORD PTR [rsp+40], rax
.L4:
        mov     ebp, DWORD PTR [rsp+32]
        xor     r13d, r13d
        sar     ebp
        add     ebp, DWORD PTR [rsp+120]
        movsx   rbp, ebp
        imul    rbp, QWORD PTR [rsp+24]
.L5:
        movzx   eax, BYTE PTR [r15+1+r13*4]
        pxor    xmm2, xmm2
        pxor    xmm1, xmm1
        pxor    xmm0, xmm0
        pxor    xmm3, xmm3
        pxor    xmm4, xmm4
        cvtsi2ss        xmm2, eax
        movzx   eax, BYTE PTR [r15+r13*4]
        cvtsi2ss        xmm1, eax
        mov     eax, r13d
        sar     eax
        add     eax, DWORD PTR [rsp+112]
        cdqe
        movss   DWORD PTR [rsp+20], xmm2
        lea     rsi, [rbp+0+rax*4]
        add     rsi, r12
        movss   DWORD PTR [rsp+16], xmm1
        movzx   eax, BYTE PTR [rsi+1]
        cvtsi2ss        xmm0, eax
        movzx   eax, BYTE PTR [rsi+2]
        cvtsi2ss        xmm3, eax
        movzx   eax, BYTE PTR [rsi]
        addss   xmm0, xmm0
        addss   xmm0, xmm3
        pxor    xmm3, xmm3
        cvtsi2ss        xmm3, eax
        movzx   eax, BYTE PTR [r15+2+r13*4]
        addss   xmm0, xmm3
        mulss   xmm0, DWORD PTR .LC0[rip]
        mulss   xmm0, DWORD PTR .LC1[rip]
        cvtss2sd        xmm4, xmm0
        pxor    xmm0, xmm0
        movsd   QWORD PTR [rsp+8], xmm4
        cvtsi2sd        xmm0, eax
        mulsd   xmm0, QWORD PTR .LC2[rip]
        addsd   xmm0, xmm4
        cvttsd2si       edi, xmm0
        call    utils_saturate
        movss   xmm2, DWORD PTR [rsp+20]
        pxor    xmm0, xmm0
        mov     BYTE PTR [rbx+2+r13*4], al
        cvtss2sd        xmm0, xmm2
        mulsd   xmm0, QWORD PTR .LC2[rip]
        addsd   xmm0, QWORD PTR [rsp+8]
        cvttsd2si       edi, xmm0
        call    utils_saturate
        movss   xmm1, DWORD PTR [rsp+16]
        pxor    xmm0, xmm0
        mov     BYTE PTR [rbx+1+r13*4], al
        cvtss2sd        xmm0, xmm1
        mulsd   xmm0, QWORD PTR .LC2[rip]
        addsd   xmm0, QWORD PTR [rsp+8]
        cvttsd2si       edi, xmm0
        call    utils_saturate
        mov     BYTE PTR [rbx+r13*4], al
        mov     rax, r13
        add     r13, 1
        cmp     rax, r14
        jne     .L5
        add     DWORD PTR [rsp+32], 1
        add     r15, QWORD PTR [rsp+24]
        mov     eax, DWORD PTR [rsp+32]
        add     rbx, QWORD PTR [rsp+40]
        cmp     DWORD PTR [rsp+36], eax
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
.LC0:
        .long   1048576000
.LC1:
        .long   1056964608
.LC2:
        .long   3435973837
        .long   1072483532