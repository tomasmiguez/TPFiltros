ImagenFantasma_c:
        push    rbp
        mov     rbp, rsp
        push    r15
        push    r14
        push    r13
        push    r12
        push    rbx
        sub     rsp, 152
        mov     QWORD PTR [rbp-152], rdi
        mov     QWORD PTR [rbp-160], rsi
        mov     DWORD PTR [rbp-164], edx
        mov     DWORD PTR [rbp-168], ecx
        mov     DWORD PTR [rbp-172], r8d
        mov     DWORD PTR [rbp-176], r9d
        mov     eax, DWORD PTR [rbp-172]
        add     eax, 3
        lea     edx, [rax+3]
        test    eax, eax
        cmovs   eax, edx
        sar     eax, 2
        mov     ebx, eax
        movsx   rax, ebx
        sub     rax, 1
        mov     QWORD PTR [rbp-64], rax
        movsx   rax, ebx
        mov     QWORD PTR [rbp-192], rax
        mov     QWORD PTR [rbp-184], 0
        mov     eax, DWORD PTR [rbp-172]
        add     eax, 3
        lea     edx, [rax+3]
        test    eax, eax
        cmovs   eax, edx
        sar     eax, 2
        movsx   rdx, eax
        sub     rdx, 1
        mov     QWORD PTR [rbp-56], rdx
        cdqe
        mov     r12, rax
        mov     r13d, 0
        mov     rax, QWORD PTR [rbp-152]
        mov     QWORD PTR [rbp-80], rax
        mov     eax, DWORD PTR [rbp-176]
        add     eax, 3
        lea     edx, [rax+3]
        test    eax, eax
        cmovs   eax, edx
        sar     eax, 2
        mov     r12d, eax
        movsx   rax, r12d
        sub     rax, 1
        mov     QWORD PTR [rbp-88], rax
        movsx   rax, r12d
        mov     r14, rax
        mov     r15d, 0
        mov     eax, DWORD PTR [rbp-176]
        add     eax, 3
        lea     edx, [rax+3]
        test    eax, eax
        cmovs   eax, edx
        sar     eax, 2
        movsx   rdx, eax
        sub     rdx, 1
        mov     QWORD PTR [rbp-96], rdx
        cdqe
        mov     r10, rax
        mov     r11d, 0
        mov     rax, QWORD PTR [rbp-160]
        mov     QWORD PTR [rbp-104], rax
        mov     DWORD PTR [rbp-72], 0
        jmp     .L2
.L5:
        mov     DWORD PTR [rbp-68], 0
        jmp     .L3
.L4:
        mov     eax, DWORD PTR [rbp-72]
        movsx   rdx, eax
        movsx   rax, ebx
        imul    rax, rdx
        lea     rdx, [0+rax*4]
        mov     rax, QWORD PTR [rbp-80]
        add     rdx, rax
        mov     eax, DWORD PTR [rbp-68]
        cdqe
        movzx   eax, BYTE PTR [rdx+2+rax*4]
        movzx   eax, al
        cvtsi2ss        xmm0, eax
        movss   DWORD PTR [rbp-108], xmm0
        mov     eax, DWORD PTR [rbp-72]
        movsx   rdx, eax
        movsx   rax, ebx
        imul    rax, rdx
        lea     rdx, [0+rax*4]
        mov     rax, QWORD PTR [rbp-80]
        add     rdx, rax
        mov     eax, DWORD PTR [rbp-68]
        cdqe
        movzx   eax, BYTE PTR [rdx+1+rax*4]
        movzx   eax, al
        cvtsi2ss        xmm0, eax
        movss   DWORD PTR [rbp-112], xmm0
        mov     eax, DWORD PTR [rbp-72]
        movsx   rdx, eax
        movsx   rax, ebx
        imul    rax, rdx
        lea     rdx, [0+rax*4]
        mov     rax, QWORD PTR [rbp-80]
        add     rdx, rax
        mov     eax, DWORD PTR [rbp-68]
        cdqe
        movzx   eax, BYTE PTR [rdx+rax*4]
        movzx   eax, al
        cvtsi2ss        xmm0, eax
        movss   DWORD PTR [rbp-116], xmm0
        mov     eax, DWORD PTR [rbp-72]
        mov     edx, eax
        shr     edx, 31
        add     eax, edx
        sar     eax
        mov     edx, eax
        mov     eax, DWORD PTR [rbp+24]
        add     eax, edx
        mov     DWORD PTR [rbp-120], eax
        mov     eax, DWORD PTR [rbp-68]
        mov     edx, eax
        shr     edx, 31
        add     eax, edx
        sar     eax
        mov     edx, eax
        mov     eax, DWORD PTR [rbp+16]
        add     eax, edx
        mov     DWORD PTR [rbp-124], eax
        mov     eax, DWORD PTR [rbp-120]
        movsx   rdx, eax
        movsx   rax, ebx
        imul    rax, rdx
        lea     rdx, [0+rax*4]
        mov     rax, QWORD PTR [rbp-80]
        add     rdx, rax
        mov     eax, DWORD PTR [rbp-124]
        cdqe
        movzx   eax, BYTE PTR [rdx+2+rax*4]
        movzx   eax, al
        cvtsi2ss        xmm0, eax
        movss   DWORD PTR [rbp-128], xmm0
        mov     eax, DWORD PTR [rbp-120]
        movsx   rdx, eax
        movsx   rax, ebx
        imul    rax, rdx
        lea     rdx, [0+rax*4]
        mov     rax, QWORD PTR [rbp-80]
        add     rdx, rax
        mov     eax, DWORD PTR [rbp-124]
        cdqe
        movzx   eax, BYTE PTR [rdx+1+rax*4]
        movzx   eax, al
        cvtsi2ss        xmm0, eax
        movss   DWORD PTR [rbp-132], xmm0
        mov     eax, DWORD PTR [rbp-120]
        movsx   rdx, eax
        movsx   rax, ebx
        imul    rax, rdx
        lea     rdx, [0+rax*4]
        mov     rax, QWORD PTR [rbp-80]
        add     rdx, rax
        mov     eax, DWORD PTR [rbp-124]
        cdqe
        movzx   eax, BYTE PTR [rdx+rax*4]
        movzx   eax, al
        cvtsi2ss        xmm0, eax
        movss   DWORD PTR [rbp-136], xmm0
        movss   xmm0, DWORD PTR [rbp-132]
        addss   xmm0, xmm0
        addss   xmm0, DWORD PTR [rbp-128]
        addss   xmm0, DWORD PTR [rbp-136]
        movss   xmm1, DWORD PTR .LC0[rip]
        divss   xmm0, xmm1
        movss   DWORD PTR [rbp-140], xmm0
        cvtss2sd        xmm1, DWORD PTR [rbp-108]
        movsd   xmm0, QWORD PTR .LC1[rip]
        mulsd   xmm1, xmm0
        movss   xmm0, DWORD PTR [rbp-140]
        movss   xmm2, DWORD PTR .LC2[rip]
        divss   xmm0, xmm2
        cvtss2sd        xmm0, xmm0
        addsd   xmm0, xmm1
        cvttsd2si       eax, xmm0
        mov     edx, DWORD PTR [rbp-72]
        movsx   rcx, edx
        movsx   rdx, r12d
        imul    rdx, rcx
        lea     rcx, [0+rdx*4]
        mov     rdx, QWORD PTR [rbp-104]
        lea     r13, [rcx+rdx]
        mov     edi, eax
        call    utils_saturate
        mov     edx, DWORD PTR [rbp-68]
        movsx   rdx, edx
        mov     BYTE PTR [r13+2+rdx*4], al
        cvtss2sd        xmm1, DWORD PTR [rbp-112]
        movsd   xmm0, QWORD PTR .LC1[rip]
        mulsd   xmm1, xmm0
        movss   xmm0, DWORD PTR [rbp-140]
        movss   xmm2, DWORD PTR .LC2[rip]
        divss   xmm0, xmm2
        cvtss2sd        xmm0, xmm0
        addsd   xmm0, xmm1
        cvttsd2si       eax, xmm0
        mov     edx, DWORD PTR [rbp-72]
        movsx   rcx, edx
        movsx   rdx, r12d
        imul    rdx, rcx
        lea     rcx, [0+rdx*4]
        mov     rdx, QWORD PTR [rbp-104]
        lea     r13, [rcx+rdx]
        mov     edi, eax
        call    utils_saturate
        mov     edx, DWORD PTR [rbp-68]
        movsx   rdx, edx
        mov     BYTE PTR [r13+1+rdx*4], al
        cvtss2sd        xmm1, DWORD PTR [rbp-116]
        movsd   xmm0, QWORD PTR .LC1[rip]
        mulsd   xmm1, xmm0
        movss   xmm0, DWORD PTR [rbp-140]
        movss   xmm2, DWORD PTR .LC2[rip]
        divss   xmm0, xmm2
        cvtss2sd        xmm0, xmm0
        addsd   xmm0, xmm1
        cvttsd2si       eax, xmm0
        mov     edx, DWORD PTR [rbp-72]
        movsx   rcx, edx
        movsx   rdx, r12d
        imul    rdx, rcx
        lea     rcx, [0+rdx*4]
        mov     rdx, QWORD PTR [rbp-104]
        lea     r13, [rcx+rdx]
        mov     edi, eax
        call    utils_saturate
        mov     edx, DWORD PTR [rbp-68]
        movsx   rdx, edx
        mov     BYTE PTR [r13+0+rdx*4], al
        add     DWORD PTR [rbp-68], 1
.L3:
        mov     eax, DWORD PTR [rbp-68]
        cmp     eax, DWORD PTR [rbp-164]
        jl      .L4
        add     DWORD PTR [rbp-72], 1
.L2:
        mov     eax, DWORD PTR [rbp-72]
        cmp     eax, DWORD PTR [rbp-168]
        jl      .L5
        nop
        nop
        add     rsp, 152
        pop     rbx
        pop     r12
        pop     r13
        pop     r14
        pop     r15
        pop     rbp
        ret
.LC0:
        .long   1082130432
.LC1:
        .long   3435973837
        .long   1072483532
.LC2:
        .long   1073741824