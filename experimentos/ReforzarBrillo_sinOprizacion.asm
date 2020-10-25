ReforzarBrillo_c:
    push    rbp
    mov     rbp, rsp
    push    r15
    push    r14
    push    r13
    push    r12
    push    rbx
    sub     rsp, 120
    mov     QWORD PTR [rbp-120], rdi
    mov     QWORD PTR [rbp-128], rsi
    mov     DWORD PTR [rbp-132], edx
    mov     DWORD PTR [rbp-136], ecx
    mov     DWORD PTR [rbp-140], r8d
    mov     DWORD PTR [rbp-144], r9d
    mov     eax, DWORD PTR [rbp-140]
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
    mov     QWORD PTR [rbp-160], rax
    mov     QWORD PTR [rbp-152], 0
    mov     eax, DWORD PTR [rbp-140]
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
    mov     rax, QWORD PTR [rbp-120]
    mov     QWORD PTR [rbp-80], rax
    mov     eax, DWORD PTR [rbp-144]
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
    mov     eax, DWORD PTR [rbp-144]
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
    mov     rax, QWORD PTR [rbp-128]
    mov     QWORD PTR [rbp-104], rax
    mov     DWORD PTR [rbp-72], 0
    jmp     .L2
.L8:
    mov     DWORD PTR [rbp-68], 0
    jmp     .L3
.L7:
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
    movzx   ecx, al
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
    add     eax, eax
    add     ecx, eax
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
    add     eax, ecx
    lea     edx, [rax+3]
    test    eax, eax
    cmovs   eax, edx
    sar     eax, 2
    mov     DWORD PTR [rbp-108], eax
    mov     eax, DWORD PTR [rbp-108]
    cmp     eax, DWORD PTR [rbp+16]
    jle     .L4
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
    movzx   edx, al
    mov     eax, DWORD PTR [rbp+32]
    add     eax, edx
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
    movzx   edx, al
    mov     eax, DWORD PTR [rbp+32]
    add     eax, edx
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
    movzx   edx, al
    mov     eax, DWORD PTR [rbp+32]
    add     eax, edx
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
    jmp     .L5
.L4:
    mov     eax, DWORD PTR [rbp+24]
    cmp     eax, DWORD PTR [rbp-108]
    jle     .L6
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
    sub     eax, DWORD PTR [rbp+40]
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
    sub     eax, DWORD PTR [rbp+40]
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
    sub     eax, DWORD PTR [rbp+40]
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
    jmp     .L5
.L6:
    mov     eax, DWORD PTR [rbp-72]
    movsx   rdx, eax
    movsx   rax, ebx
    imul    rax, rdx
    lea     rdx, [0+rax*4]
    mov     rax, QWORD PTR [rbp-80]
    add     rdx, rax
    mov     eax, DWORD PTR [rbp-72]
    movsx   rcx, eax
    movsx   rax, r12d
    imul    rax, rcx
    lea     rcx, [0+rax*4]
    mov     rax, QWORD PTR [rbp-104]
    add     rcx, rax
    mov     eax, DWORD PTR [rbp-68]
    cdqe
    movzx   edx, BYTE PTR [rdx+rax*4]
    mov     eax, DWORD PTR [rbp-68]
    cdqe
    mov     BYTE PTR [rcx+rax*4], dl
    mov     eax, DWORD PTR [rbp-72]
    movsx   rdx, eax
    movsx   rax, ebx
    imul    rax, rdx
    lea     rdx, [0+rax*4]
    mov     rax, QWORD PTR [rbp-80]
    add     rdx, rax
    mov     eax, DWORD PTR [rbp-72]
    movsx   rcx, eax
    movsx   rax, r12d
    imul    rax, rcx
    lea     rcx, [0+rax*4]
    mov     rax, QWORD PTR [rbp-104]
    add     rcx, rax
    mov     eax, DWORD PTR [rbp-68]
    cdqe
    movzx   edx, BYTE PTR [rdx+1+rax*4]
    mov     eax, DWORD PTR [rbp-68]
    cdqe
    mov     BYTE PTR [rcx+1+rax*4], dl
    mov     eax, DWORD PTR [rbp-72]
    movsx   rdx, eax
    movsx   rax, ebx
    imul    rax, rdx
    lea     rdx, [0+rax*4]
    mov     rax, QWORD PTR [rbp-80]
    add     rdx, rax
    mov     eax, DWORD PTR [rbp-72]
    movsx   rcx, eax
    movsx   rax, r12d
    imul    rax, rcx
    lea     rcx, [0+rax*4]
    mov     rax, QWORD PTR [rbp-104]
    add     rcx, rax
    mov     eax, DWORD PTR [rbp-68]
    cdqe
    movzx   edx, BYTE PTR [rdx+2+rax*4]
    mov     eax, DWORD PTR [rbp-68]
    cdqe
    mov     BYTE PTR [rcx+2+rax*4], dl
.L5:
    add     DWORD PTR [rbp-68], 1
.L3:
    mov     eax, DWORD PTR [rbp-68]
    cmp     eax, DWORD PTR [rbp-132]
    jl      .L7
    add     DWORD PTR [rbp-72], 1
.L2:
    mov     eax, DWORD PTR [rbp-72]
    cmp     eax, DWORD PTR [rbp-136]
    jl      .L8
    nop
    nop
    add     rsp, 120
    pop     rbx
    pop     r12
    pop     r13
    pop     r14
    pop     r15
    pop     rbp
    ret