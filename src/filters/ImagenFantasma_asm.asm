extern ImagenFantasma_c
global ImagenFantasma_asm

section .rodata
; Defino las mascaras
ALIGN 16

select_red:   db 0x02, 0x80, 0x80, 0x80, 0x06, 0x80, 0x80, 0x80, 0x0A, 0x80, 0x80, 0x80, 0x0E, 0x80, 0x80, 0x80
select_green: db 0x01, 0x80, 0x80, 0x80, 0x05, 0x80, 0x80, 0x80, 0x09, 0x80, 0x80, 0x80, 0x0D, 0x80, 0x80, 0x80
select_blue:  db 0x00, 0x80, 0x80, 0x80, 0x04, 0x80, 0x80, 0x80, 0x08, 0x80, 0x80, 0x80, 0x0C, 0x80, 0x80, 0x80

pshufb_alpha: db 0x80, 0x80, 0x80, 0x03, 0x80, 0x80, 0x80, 0x07, 0x80, 0x80, 0x80, 0x0B, 0x80, 0x80, 0x80, 0x0F
; Las comentadas estan al reves!
;pshufb_red:   db 0x80, 0x80, 0x01, 0x80, 0x80, 0x80, 0x02, 0x80, 0x80, 0x80, 0x03, 0x80, 0x80, 0x80, 0x04, 0x80
;pshufb_green: db 0x80, 0x01, 0x80, 0x80, 0x80, 0x02, 0x80, 0x80, 0x80, 0x03, 0x80, 0x80, 0x80, 0x04, 0x80, 0x80
;pshufb_blue:  db 0x01, 0x80, 0x80, 0x80, 0x02, 0x80, 0x80, 0x80, 0x03, 0x80, 0x80, 0x80, 0x04, 0x80, 0x80, 0x80
pshufb_red:   db 0x80, 0x80, 0x04, 0x80, 0x80, 0x80, 0x03, 0x80, 0x80, 0x80, 0x02, 0x80, 0x80, 0x80, 0x01, 0x80
pshufb_green: db 0x80, 0x04, 0x80, 0x80, 0x80, 0x03, 0x80, 0x80, 0x80, 0x02, 0x80, 0x80, 0x80, 0x01, 0x80, 0x80
pshufb_blue:  db 0x04, 0x80, 0x80, 0x80, 0x03, 0x80, 0x80, 0x80, 0x02, 0x80, 0x80, 0x80, 0x01, 0x80, 0x80, 0x80

mask_2:   dd 2.0, 2.0, 2.0, 2.0
mask_0_9: dd 0.9, 0.9, 0.9, 0.9

section .text
; Ancho de la imagen mayor a 16 pixeles y multiplo de 8 pixeles

; void ImagenFantasma_asm (uint8_t *src,
;                          uint8_t *dst,
;                          int width,
;                          int height,
;                          int src_row_size,
;                          int dst_row_size,
;                          int offsetx,
;                          int offsety);

; rdi = uint8_t *src
; rsi = uint8_t* dst
; edx = int width
; ecx = int height
; r8d = int src_row_size
; r9d = int dst_row_size
; pila = offsetx
; pila = offsety
; Retorna void

; Estado de la pila:
; (-)
; |   rip   | rsp |
; | offsetx |     |
; | offsety |     |
; (+)

ImagenFantasma_asm:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15
    

    ; Estado de la pila:
    ; (-)
    ; |   r15   |  rsp    |
    ; |   r14   |  rbp-24 |
    ; |   r13   |  rbp-16 |
    ; |   r12   |  rbp-8  |
    ; |   rbp   |  rbp    |
    ; |   rip   |  rbp+8  |
    ; | offsetx |  rbp+16 |
    ; | offsety |  rbp+24 |
    ; (+)

    mov r12d, edx
    shr r12d, 2                             ; r12d = width/4
    mov r13, rdi
    mov r14d, edx                           ; r14d = width
    shl r14d, 5                             ; r14d = width*32
    ;mov r15d, edx                           ; r15d = width
    ;imul r15d, ecx                          ; r15d = width*height
    ;shl r15d, 5                             ; r15d = width*height*32

    ; Guardo las mascaras en registros xmm para no tener que hacerlo en cada iteracion
    movdqu xmm15, [select_red]
    movdqu xmm14, [select_green]
    movdqu xmm13, [select_blue]

    movdqu xmm12, [mask_2]
    movdqu xmm11, [mask_0_9]

    movdqu xmm10, [pshufb_alpha]
    movdqu xmm9, [pshufb_red]
    movdqu xmm8, [pshufb_green]
    movdqu xmm7, [pshufb_blue]
    
    xor r8, r8                                      ; r8 = 0

.loopFilas:
    ; En pixeles
    cmp r8d, ecx
    jge .fin

    xor r9, r9
    .loopColumnas:
        ;cmp r9d, r14d
        ; En pixeles
        cmp r9d, edx
        jge .actualizoLoopFilas
        
        
        ; Calculo indices de la img fantasma EN PIXELES
        mov r10d, r8d                       ; r10 = i
        shr r10d, 1                         ; r10 = i/2
        add r10d, [rbp + 24]                ; r10 = i/2 + offsety = ii

        mov r11d, r9d                       ; r11 = j
        shr r11d, 1                         ; r11 = j/2
        add r11d, [rbp + 16]                ; r11 = j/2 + offsetx = jj

        ; En pixeles
        mov eax, r10d
        imul eax, r14d
        mov r15d, r11d
        shl r15d, 5
        add eax, r15d
        

        ;imul r10d, edx                      ; r10d = ii*width
        ;lea r10d, [r10d + r11d * 4]         ; r10d += jj*4 
        ;mov r11, r13                        ; r11 = rdi
        ;lea r11, [r11 + r10]                ; rdi += r10
        ;add r10d, r11d                     ; r10 = ii + jj

        ; Obtengo rrr-ggg-bbb
        ; Guardo copias para los distintos colores de la img fantasma
        movdqu xmm0, [r13 + rax]            ; xmm0 : [a3 r3 g3 b3 | a2 r2 g2 b2 | a1 r1 g1 b1 | a0 r0 g0 b0]
        movdqu xmm1, xmm0                   ; xmm1 : [a3 r3 g3 b3 | a2 r2 g2 b2 | a1 r1 g1 b1 | a0 r0 g0 b0]
        movdqu xmm2, xmm0                   ; xmm2 : [a3 r3 g3 b3 | a2 r2 g2 b2 | a1 r1 g1 b1 | a0 r0 g0 b0]
        movdqu xmm3, xmm0                   ; xmm3 : [a3 r3 g3 b3 | a2 r2 g2 b2 | a1 r1 g1 b1 | a0 r0 g0 b0]

        ; Extiendo cada color con ceros (son unsigned)
        pshufb xmm1, xmm15                  ; xmm1 : [00 00 00 r3 | 00 00 00 r2 | 00 00 00 r1 | 00 00 00 r0]
        pshufb xmm2, xmm14                  ; xmm2 : [00 00 00 g3 | 00 00 00 g2 | 00 00 00 g1 | 00 00 00 g0]
        pshufb xmm3, xmm13                  ; xmm3 : [00 00 00 b3 | 00 00 00 b2 | 00 00 00 b1 | 00 00 00 b0]

        ; Convierto cada uno a float
        cvtdq2ps xmm1, xmm1                 ; xmm1 : [ (float)r3 | (float)r2 | (float)r1 | (float)r0 ]
        cvtdq2ps xmm2, xmm2                 ; xmm2 : [ (float)g3 | (float)g2 | (float)g1 | (float)g0 ]
        cvtdq2ps xmm3, xmm3                 ; xmm3 : [ (float)b3 | (float)b2 | (float)b1 | (float)b0 ]
        
        ; Hago el calculo para obtener b
        mulps xmm2, xmm12                   ; xmm2 : [ (float)g3*2 | (float)g2*2 | (float)g1*2 | (float)g0*2 ]
        addps xmm1, xmm2
        ; xmm1 : [ (float)r3+(float)g3*2 | (float)r2+(float)g2*2 | (float)r1+(float)g1*2 | (float)r0+(float)g0*2 ]
        addps xmm1, xmm3
        ; xmm1 : [ rrr3+2*ggg3+bbb3 | rrr2+2*ggg2+bbb2 | rrr1+2*ggg1+bbb1 | rrr0+2*ggg0+bbb0 ]
        divps xmm1, xmm12
        ; xmm1 : [ (rrr3+2*ggg3+bbb3)/2 | (rrr2+2*ggg2+bbb2)/2 | (rrr1+2*ggg1+bbb1)/2 | (rrr0+2*ggg0+bbb0)/2 ]
        divps xmm1, xmm12
        ; xmm1 : [ (rrr3+2*ggg3+bbb3)/4 | (rrr2+2*ggg2+bbb2)/4 | (rrr1+2*ggg1+bbb1)/4 | (rrr0+2*ggg0+bbb0)/4 ]


        ; Obtengo rr-gg-bb
        ; Guardo copias para los distintos colores
        ; En BITS
        ;mov eax, r8d
        ;add eax, r9d
        
        ; En pixeles
        mov eax, r8d                                     ; eax = i esta en pixeles
        imul eax, r14d                                   ; eax = i * largo en pixeles * 32 bits
        mov r15d, r9d                                    ; r15d = j
        shl r15d, 5                                      ; r15d = j * 32
        add eax, r15d                                    ; eax = i*width*32 + j*32
        
        movdqu xmm0, [rdi + rax]            ; xmm0 : [a3 r3 g3 b3 | a2 r2 g2 b2 | a1 r1 g1 b1 | a0 r0 g0 b0]
        movdqu xmm2, xmm0                   ; xmm2 : [a3 r3 g3 b3 | a2 r2 g2 b2 | a1 r1 g1 b1 | a0 r0 g0 b0]
        movdqu xmm3, xmm0                   ; xmm3 : [a3 r3 g3 b3 | a2 r2 g2 b2 | a1 r1 g1 b1 | a0 r0 g0 b0]
        movdqu xmm4, xmm0                   ; xmm4 : [a3 r3 g3 b3 | a2 r2 g2 b2 | a1 r1 g1 b1 | a0 r0 g0 b0]
        
        pshufb xmm2, xmm15                  ; xmm2 : [00 00 00 r3 | 00 00 00 r2 | 00 00 00 r1 | 00 00 00 r0]
        pshufb xmm3, xmm14                  ; xmm3 : [00 00 00 g3 | 00 00 00 g2 | 00 00 00 g1 | 00 00 00 g0]
        pshufb xmm4, xmm13                  ; xmm4 : [00 00 00 b3 | 00 00 00 b2 | 00 00 00 b1 | 00 00 00 b0]

        ; Convierto cada uno a float
        cvtdq2ps xmm2, xmm2                 ; xmm2 : [ (float)rr3 | (float)rr2 | (float)rr1 | (float)rr0 ]
        cvtdq2ps xmm3, xmm3                 ; xmm3 : [ (float)gg3 | (float)gg2 | (float)gg1 | (float)gg0 ]
        cvtdq2ps xmm4, xmm4                 ; xmm4 : [ (float)bb3 | (float)bb2 | (float)bb1 | (float)bb0 ]

        divps xmm1, xmm12
        ; xmm1 : [ (rrr3+2*ggg3+bbb3)/8 | (rrr2+2*ggg2+bbb2)/8 | (rrr1+2*ggg1+bbb1)/8 | (rrr0+2*ggg0+bbb0)/8 ]

        mulps xmm2, xmm11
        ; xmm2 : [ (float)rr3*0.9 | (float)rr2*0.9 | (float)rr1*0.9 | (float)rr0*0.9 ]
        
        mulps xmm3, xmm11
        ; xmm3 : [ (float)gg3*0.9 | (float)gg2*0.9 | (float)gg1*0.9 | (float)gg0*0.9 ]

        mulps xmm4, xmm11
        ; xmm4 : [ (float)bb3*0.9 | (float)bb2*0.9 | (float)bb1*0.9 | (float)bb0*0.9 ]

        ; Los paso a int y empaqueto para hacer la suma saturada
        cvtps2dq xmm1, xmm1
        ;xmm1 : [ (int)((rrr3+2*ggg3+bbb3)/8) 
        ;       | (int)((rrr2+2*ggg2+bbb2)/8)
        ;       | (int)((rrr1+2*ggg1+bbb1)/8)
        ;       | (int)((rrr0+2*ggg0+bbb0)/8) ]add 

        cvtps2dq xmm2, xmm2
        ; xmm2 : [ (int)((float)rr3*0.9) | (int)((float)rr2*0.9) | (int)((float)rr1*0.9) | (int)((float)rr0*0.9) ]
        cvtps2dq xmm3, xmm3
        ; xmm3 : [ (int)((float)gg3*0.9) | (int)((float)gg2*0.9) | (int)((float)gg1*0.9) | (int)((float)gg0*0.9) ]
        cvtps2dq xmm4, xmm4
        ; xmm4 : [ (int)((float)bb3*0.9) | (int)((float)bb2*0.9) | (int)((float)bb1*0.9) | (int)((float)bb0*0.9) ]

        packssdw xmm1, xmm1
        ;xmm1 : [ (int)((rrr3+2*ggg3+bbb3)/8)
        ;       | (int)((rrr2+2*ggg2+bbb2)/8)
        ;       | (int)((rrr1+2*ggg1+bbb1)/8)
        ;       | (int)((rrr0+2*ggg0+bbb0)/8)
        ;       | (int)((rrr3+2*ggg3+bbb3)/8)
        ;       | (int)((rrr2+2*ggg2+bbb2)/8)
        ;       | (int)((rrr1+2*ggg1+bbb1)/8)
        ;       | (int)((rrr0+2*ggg0+bbb0)/8) ]

        packssdw xmm2, xmm2
        ;xmm2 : [ (int)((float)rr3*0.9)
        ;       | (int)((float)rr2*0.9)
        ;       | (int)((float)rr1*0.9)
        ;       | (int)((float)rr0*0.9)
        ;       | (int)((float)rr3*0.9)
        ;       | (int)((float)rr2*0.9)
        ;       | (int)((float)rr1*0.9)
        ;       | (int)((float)rr0*0.9) ]

        packssdw xmm3, xmm3
        ;xmm3 : [ (int)((float)gg3*0.9)
        ;       | (int)((float)gg2*0.9)
        ;       | (int)((float)gg1*0.9)
        ;       | (int)((float)gg0*0.9)
        ;       | (int)((float)gg3*0.9)
        ;       | (int)((float)gg2*0.9)
        ;       | (int)((float)gg1*0.9)
        ;       | (int)((float)gg0*0.9) ]
        
        packssdw xmm4, xmm4
        ;xmm4 : [ (int)((float)bb3*0.9)
        ;       | (int)((float)bb2*0.9)
        ;       | (int)((float)bb1*0.9)
        ;       | (int)((float)bb0*0.9)
        ;       | (int)((float)bb3*0.9)
        ;       | (int)((float)bb2*0.9)
        ;       | (int)((float)bb1*0.9)
        ;       | (int)((float)bb0*0.9) ]
        
        ; Hago la sumas saturadas
        paddsw xmm2, xmm1
        ;xmm2 : [ (int)((float)rr3*0.9) + (int)((rrr3+2*ggg3+bbb3)/8)
        ;       | (int)((float)rr2*0.9) + (int)((rrr2+2*ggg2+bbb2)/8)
        ;       | (int)((float)rr1*0.9) + (int)((rrr1+2*ggg1+bbb1)/8)
        ;       | (int)((float)rr0*0.9) + (int)((rrr0+2*ggg0+bbb0)/8)
        ;       | (int)((float)rr3*0.9) + (int)((rrr3+2*ggg3+bbb3)/8)
        ;       | (int)((float)rr2*0.9) + (int)((rrr2+2*ggg2+bbb2)/8)
        ;       | (int)((float)rr1*0.9) + (int)((rrr1+2*ggg1+bbb1)/8)
        ;       | (int)((float)rr0*0.9) + (int)((rrr0+2*ggg0+bbb0)/8) ]

        paddsw xmm3, xmm1
        ;xmm3 : [ (int)((float)gg3*0.9) + (int)((rrr3+2*ggg3+bbb3)/8)
        ;       | (int)((float)gg2*0.9) + (int)((rrr2+2*ggg2+bbb2)/8)
        ;       | (int)((float)gg1*0.9) + (int)((rrr1+2*ggg1+bbb1)/8)
        ;       | (int)((float)gg0*0.9) + (int)((rrr0+2*ggg0+bbb0)/8)
        ;       | (int)((float)gg3*0.9) + (int)((rrr3+2*ggg3+bbb3)/8)
        ;       | (int)((float)gg2*0.9) + (int)((rrr2+2*ggg2+bbb2)/8)
        ;       | (int)((float)gg1*0.9) + (int)((rrr1+2*ggg1+bbb1)/8)
        ;       | (int)((float)gg0*0.9) + (int)((rrr0+2*ggg0+bbb0)/8) ]

        paddsw xmm4, xmm1
        ;xmm4 : (+)[ (int)((float)bb3*0.9) + (int)((rrr3+2*ggg3+bbb3)/8)
        ;       | (int)((float)bb2*0.9) + (int)((rrr2+2*ggg2+bbb2)/8)
        ;       | (int)((float)bb1*0.9) + (int)((rrr1+2*ggg1+bbb1)/8)
        ;       | (int)((float)bb0*0.9) + (int)((rrr0+2*ggg0+bbb0)/8)
        ;       | (int)((float)bb3*0.9) + (int)((rrr3+2*ggg3+bbb3)/8)
        ;       | (int)((float)bb2*0.9) + (int)((rrr2+2*ggg2+bbb2)/8)
        ;       | (int)((float)bb1*0.9) + (int)((rrr1+2*ggg1+bbb1)/8)
        ;       | (int)((float)bb0*0.9) + (int)((rrr0+2*ggg0+bbb0)/8) ] (-)

        packuswb xmm2, xmm2
        ;xmm2 : [ dst.r3 | dst.r2 | dst.r1 | dst.r0 
        ;       | dst.r3 | dst.r2 | dst.r1 | dst.r0
        ;       | dst.r3 | dst.r2 | dst.r1 | dst.r0
        ;       | dst.r3 | dst.r2 | dst.r1 | dst.r0]
        
        packuswb xmm3, xmm3
        ;xmm3 : [ dst.g3 | dst.g2 | dst.g1 | dst.g0 
        ;       | dst.g3 | dst.g2 | dst.g1 | dst.g0
        ;       | dst.g3 | dst.g2 | dst.g1 | dst.g0
        ;       | dst.g3 | dst.g2 | dst.g1 | dst.g0]

        packuswb xmm4, xmm4
        ;xmm4 : [ dst.b3 | dst.b2 | dst.b1 | dst.b0 
        ;       | dst.b3 | dst.b2 | dst.b1 | dst.b0
        ;       | dst.b3 | dst.b2 | dst.b1 | dst.b0
        ;       | dst.b3 | dst.b2 | dst.b1 | dst.b0] 

        pshufb xmm0, xmm10
    ;xmm0: [a3 |    0   |   0    |   0    | a2 |   0    |   0    |   0    | a1 |   0    |   0    |   0    | a0 |   0    |   0    |   0   ]
        pshufb xmm2, xmm9
    ;xmm2: [ 0 | dst.r3 |   0    |   0    | 0  | dst.r2 |   0    |   0    | 0  | dst.r1 |   0    |   0    | 0  | dst.r0 |   0    |   0   ]
        pshufb xmm3, xmm8
    ;xmm3: [ 0 |    0   | dst.g3 |   0    | 0  |   0    | dst.g2 |   0    | 0  |   0    | dst.g1 |   0    | 0  |   0    | dst.g0 |   0   ]
        pshufb xmm4, xmm7
    ;xmm4: [ 0 |    0   |    0   | dst.b3 | 0  |   0    |   0    | dst.b2 | 0  |   0    |   0    | dst.b1 | 0  |   0    |   0    | dst.b0]
        
        ; Uno los colores para formar los pixeles nuevos
        por xmm0, xmm2
    ;xmm0: [a3 | dst.r3 |   0    |   0    | a2 | dst.r2 |   0    |   0    | a1 | dst.r1 |   0    |   0    | a0 | dst.r0 |   0    |   0   ]
        por xmm0, xmm3
    ;xmm0: [a3 | dst.r3 | dst.g3 |   0    | a2 | dst.r2 | dst.g2 |   0    | a1 | dst.r1 | dst.g1 |   0    | a0 | dst.r0 | dst.g0 |   0   ]
        por xmm0, xmm4
    ;xmm0: [a3 | dst.r3 | dst.g3 | dst.b3 | a2 | dst.r2 | dst.g2 | dst.b2 | a1 | dst.r1 | dst.g1 | dst.b1 | a0 | dst.r0 | dst.g0 | dst.b0 ]

        ;movdqu [rsi], xmm0
        ;inc r9d
        ;mov eax, r8d                                    ; eax = i
        ;imul eax, edx                                   ; eax = i*width
        ;lea eax, [eax + r9d * 4]                        ; eax += j*4 
        ;lea rdi, [rdi + rax]                            ; rdi += rax
        ;lea rsi, [rsi + rax]                            ; rsi += rax
        ;jmp .loopColumnas
        
        ; En pixeles
        movdqu [rsi + rax], xmm0
        add r9d, 4                                       ; j esta en pixeles
        jmp .loopColumnas

        ; En bits:
        ;movdqu [rsi + rax], xmm0
        ;add r9d, 128
        ;jmp .loopColumnas

.actualizoLoopFilas:
    ; Agregarle a r8d width*32= width * largo de pixel en bits
    ; Compararlo con width*height*32= largo de la matriz en bits
    ;add r8d, r14d
    ;jmp .loopFilas

    ; En pixeles
    inc r8d 
    jmp .loopFilas

.fin:
    ; Actualizo variables de control
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret