section .rodata
ALIGN 16

mask_pshufb_u: dq 0x0100010001000100,0x0100010001000100
mask_pshufb_b: dq 0x0000000000000000,0x0000000000000000
mask_pshufb_1: db 0x01,0x80,0x02,0x80,0x05,0x80,0x06,0x80,0x09,0x80,0x0A,0x80,0x0D,0x80,0x0E,0x80
mask_pshufb_2: db 0x01,0x80,0x00,0x80,0x05,0x80,0x04,0x80,0x09,0x80,0x08,0x80,0x0D,0x80,0x0C,0x80
mask_pshufb_L: db 0x00,0x01,0x00,0x01,0x02,0x03,0x02,0x03,0x04,0x05,0x04,0x05,0x06,0x07,0x06,0x07
mask_pshufb_H: db 0x08,0x09,0x08,0x09,0x0A,0x0B,0x0A,0x0B,0x0C,0x0D,0x0C,0x0D,0x0E,0x0F,0x0E,0x0F
mask_alpha: db 0x00,0x00,0x00,0xFF,0x00,0x00,0x00,0xFF,0x00,0x00,0x00,0xFF,0x00,0x00,0x00,0xFF

global ReforzarBrillo_asm

; void ReforzarBrillo_c(
; rdi      > uint8_t *src,
; rsi      > uint8_t *dst,
; edx      > int width,
; ecx      > int height,
; r8d      > int src_row_size,
; r9d      > int dst_row_size,
; [rbp+16] > int umbralSup,
; [rbp+24] > int umbralInf,
; [rbp+32] > int brilloSup,
; [rbp+40] > int brilloInf)

section .text
ReforzarBrillo_asm:
    push rbp
    mov rbp, rsp
    push rbx   ; length
    push r12   ; src
    push r13   ; dst
    push r14   ; index
    ; guardo las variables de entrada en registros
    mov r12, rdi ; r12 : src
    mov r13, rsi ; r13 : dst
    mov eax, edx ; param width
    mul ecx      ; param height
    shl rdx, 8   ; << la parte alta de edx
    or rdx, rax  ; [edx:eax]
    mov rbx, rdx ; rbx : length (en px)
    ; umbral y brillo, lo replico a lo largo de 128 bits
    movd xmm4, [rbp+16] ; uSup : xmm0[31:0]
    movd xmm5, [rbp+24] ; uInf : xmm1[31:0]
    movd xmm6, [rbp+32] ; bSup : xmm2[31:0]
    movd xmm7, [rbp+40] ; bInf : xmm3[31:0]
    ; paso de int32 a uint16 saturado, porque luego comparo a word
    packusdw xmm4, xmm4 ; uSup : xmm0[31:0] => xmm0[15:0]
    packusdw xmm5, xmm5 ; uInf : xmm1[31:0] => xmm0[15:0]
    pshufb xmm4, [mask_pshufb_u] ; repito uSup en todos las words
    pshufb xmm5, [mask_pshufb_u] ; repito uInf en todas las words
    ; paso de int16 a uint8 saturado, porque luego sumo/resto a byte
    packuswb xmm6, xmm6 ; bSup : xmm2[31:0] => xmm0[7:0]
    packuswb xmm7, xmm7 ; bInf : xmm3[31:0] => xmm0[7:0]
    pshufb xmm6, [mask_pshufb_b] ; repito bSup en todos los bytes
    pshufb xmm7, [mask_pshufb_b] ; repito bInf en todos los bytes
    ; inicializo index
    mov r14, 0

.loop:
    ; guardo en registros
    movdqu xmm0, [r12] ; xmm0 : [p3:p2:p1:p0]
    add r12, 16        ; avanzo 16 bytes (4px)
    movdqu xmm1, [r12] ; xmm1 : [p7:p6:p5:p4]
    ; reordeno en los registros para sumarlos
    movdqa xmm10, xmm0
    movdqa xmm11, xmm0
    movdqa xmm12, xmm1
    movdqa xmm13, xmm1
    pshufb xmm10, [mask_pshufb_1] ; ordeno xmm0 para suma parcial
    pshufb xmm11, [mask_pshufb_2] ; ordeno xmm0 para suma parcial
    pshufb xmm12, [mask_pshufb_1] ; ordeno xmm1 para suma parcial
    pshufb xmm13, [mask_pshufb_2] ; ordeno xmm1 para suma parcial
    ; suma parcial
    paddw xmm10, xmm11 ; |p3_1|p3_0|p2_1|p2_0|p1_1|p1_0|p0_1|p0_0|
    paddw xmm12, xmm13 ; |p7_1|p7_0|p6_1|p6_0|p5_1|p5_0|p4_1|p4_0|
    ; suma en linea completa
    phaddw xmm10, xmm12 ; |p7|p6|p5|p4|p3|p2|p1|p0|
    ; divido por 4 cada uno y obtengo los valores de cmp
    psrlw xmm10, 2 ; |b7|b6|b5|b4|b3|b2|b1|b0|
    ; comparo los b con los umbrales
    movdqa xmm11, xmm5   ; resguardo xmm2 : xmm5
    pcmpgtw xmm11, xmm10 ; comparo xmm11 > xmm5(uInf) => 0s para los inferiores
    pcmpgtw xmm10, xmm4  ; comparo xmm10 > xmm4(uSup) => 1s para los superiores
    ; reordeno al orden original los resultados
    movdqa xmm12, xmm10
    movdqa xmm13, xmm11
    pshufb xmm10, [mask_pshufb_L] ; [cmpSup3:cmpSup2:cmpSup1:cmpSup0]
    pshufb xmm11, [mask_pshufb_L] ; [cmpInf3:cmpInf2:cmpInf1:cmpInf0]
    pshufb xmm12, [mask_pshufb_H] ; [cmpSup7:cmpSup6:cmpSup5:cmpSup4]
    pshufb xmm13, [mask_pshufb_H] ; [cmpInf7:cmpInf6:cmpInf5:cmpInf4]
    ; aplico mascaras cmp en los sumadores y restadores de brillo
    pand xmm10, xmm6 ; [sum3:sum2:sum1:sum0] => en los px que corresponde
    pand xmm11, xmm7 ; [res3:res2:res1:res0] => en los px que corresponde
    pand xmm12, xmm6 ; [sum7:sum6:sum5:sum4] => en los px que corresponde
    pand xmm13, xmm7 ; [res7:res6:res5:res4] => en los px que corresponde
    ; sumo y resto en todos los px que correspondan
    paddusb xmm0, xmm10 ;  sumo lo que corresponde a xmm0 : [p3:p2:p1:p0]
    psubusb xmm0, xmm11 ; resto lo que corresponde a xmm0 : [p3:p2:p1:p0]
    paddusb xmm1, xmm12 ;  sumo lo que corresponde a xmm1 : [p7:p6:p5:p4]
    psubusb xmm1, xmm13 ; resto lo que corresponde a xmm1 : [p7:p6:p5:p4]
    ; incorporo alpha 0xFF
    por xmm0, [mask_alpha]
    por xmm1, [mask_alpha]
    ; guardo resultados de pixeles en puntero de salida
    movdqu [r13], xmm0 ; guardo primeros 4px
    add r13, 16        ; avanzo 16 bytes (4px)
    movdqu [r13], xmm1 ; guardo segundos 4px
    ; condicionales
    add r12, 16  ; avanzo 16 bytes (4px)
    add r13, 16  ; avanzo 16 bytes (4px)
    add r14, 8   ; voy de a 8px
    cmp r14, rbx ; comparo index con length
    jge .end
    jmp .loop

.end:
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret
