extern ColorBordes_c
global ColorBordes_asm

section .rodata

ALIGN 16

MASK_OR: DD 0xFF000000, 0xFF000000, 0xFF000000, 0xFF000000

section .text

; gdb --args ../build/tp2 ColorBordes -i asm ../Misery.32x16.bmp
; Cada iteracion cargamos todo esto, y procesamos los 2 pixeles p1 y p2
; | TL | T1 | T2 | TR |
; | ML | P1 | P2 | MR |
; | BL | B1 | B2 | BR |

ColorBordes_asm: ; RDI <- src / RSI <- dst / RDX <- width / RCX <- height
    PUSH RBP
    MOV RBP, RSP
    PUSH RBX
    PUSH R12
    PUSH R13
    PUSH R14
    PUSH R15
    SUB RSP, 8

    MOV RBX, RDI    ; RBX <- src
    MOV R12, RSI    ; R12 <- dst
    MOV R8, RDX     ; R8  <- width
    MOV R10, RCX    ; R10 <- height

    MOV R15, R8     ; R15 <- width
    SUB R15, 2      ; R15 <- width-2
    MOV EAX, ECX    ; EAX <- height
    SUB EAX, 2      ; EAX <- height-2
    MUL R15D
    MOV R15D, EAX   ; R15 <- (height-2)*(width-2)
    SAR R15, 1      ; R15 <- (height-2)*(width-2)/2

    MOV R14, R8
    SAR R14, 1
    DEC R14         ; R14 <- (width/2)-1

    MOV R11, R12    ; Puntero a resultado    

    MOV RCX, 0      ; Contador de iteracion
    MOV R13, 0      ; Contador de iteracion en la fila

    LEA R12, [R12+4*R8]
    ADD R12, 4
.loop:
    MOV R9, RBX
    MOVDQU XMM0, [R9]   ; XMM0  <- [ TR T2 T1 TL ]
    MOVDQA XMM1, XMM0   ; XMM1  <- [ TR T2 T1 TL ]
    PSRLDQ XMM1, 8      ; XMM1  <- [ 0  0  TR T2 ]
    PMOVZXBW XMM0, XMM0 ; XMM0  <- [ T1 TL ]
    PMOVZXBW XMM1, XMM1 ; XMM1  <- [ TR T2 ]
    LEA R9, [R9+4*R8]
    MOVDQU XMM2, [R9]   ; XMM2  <- [ MR P2 P1 ML ]
    MOVDQA XMM3, XMM2   ; XMM3  <- [ MR P2 P1 ML ]
    PSRLDQ XMM3, 8      ; XMM3  <- [ 0  0  MR P2 ]
    PMOVZXBW XMM2, XMM2 ; XMM2  <- [ P1 ML ]
    PMOVZXBW XMM3, XMM3 ; XMM3  <- [ MR P2 ]
    LEA R9, [R9+4*R8]
    MOVDQU XMM4, [R9]   ; XMM4  <- [ BR B2 B1 BL ]
    MOVDQA XMM5, XMM4   ; XMM5  <- [ BR B2 B1 BL ]
    PSRLDQ XMM5, 8      ; XMM5  <- [ 0  0  BR B2 ]
    PMOVZXBW XMM4, XMM4 ; XMM4  <- [ B1 BL ]
    PMOVZXBW XMM5, XMM5 ; XMM5  <- [ BR B2 ]

    MOVDQA XMM6, XMM0   ; XMM6  <- [ T1 TL ]
    PSUBSW XMM6, XMM1   ; XMM6  <- [ T1-TR TL-T2 ]
    PABSW XMM6, XMM6    ; XMM6  <- [ |T1-TR| |TL-T2| ]
    MOVDQA XMM15, XMM6  ; XMM15 <- [ |T1-TR| |TL-T2| ]
 
    MOVDQA XMM7, XMM2   ; XMM7  <- [ P1 ML ]
    PSUBSW XMM7, XMM3   ; XMM7  <- [ P1-MR ML-P2 ]
    PABSW XMM7, XMM7    ; XMM6  <- [ |P1-MR| |ML-P2| ]
    PADDSW XMM15, XMM7  ; XMM15 <- [ |T1-TR|+|P1-MR| |TL-T2|+|ML-P2| ]

    MOVDQA XMM8, XMM4   ; XMM8  <- [ B1 BL ]
    PSUBSW XMM8, XMM5   ; XMM8  <- [ B1-BR BL-B2]
    PABSW XMM8, XMM8    ; XMM8  <- [ |B1-BR| |BL-B2| ]
    PADDSW XMM15, XMM8  ; XMM15 <- [ |T1-TR|+|P1-MR|+|B1-BR| |TL-T2|+|ML-P2|+|BL-B2| ]
    
    MOVDQA XMM6, XMM0   ; XMM6  <- [ T1 TL ]
    PSUBSW XMM6, XMM4   ; XMM6  <- [ T1-B1 TL-BL ]
    PABSW XMM6, XMM6    ; XMM6  <- [ |T1-B1| |TL-BL| ]
    PADDSW XMM15, XMM6  ; XMM15 <- [ (|T1-B1|)+(|T1-TR|+|P1-MR|+|B1-BR|) (|TL-BL|)+(|TL-T2|+|ML-P2|+|BL-B2|) ]

    MOVDQA XMM7, XMM1   ; XMM7  <- [ TR T2 ]
    PSUBSW XMM7, XMM5   ; XMM7  <- [ TR-BR T2-B2 ]
    PABSW XMM7, XMM7    ; XMM7  <- [ |TR-BR| |T2-B2| ]
    PADDSW XMM15, XMM7  ; XMM15 <- [ (|TR-BR|+|T1-B1|)+(|T1-TR|+|P1-MR|+|B1-BR|) (|T2-B2|+|TL-BL|)+(|TL-T2|+|ML-P2|+|BL-B2|) ]

    PSRLDQ XMM6, 8      ; XMM6  <- [ 0 |T1-B1| ]
    PADDSW XMM15, XMM6  ; XMM15 <- [ (|TR-BR|+|T1-B1|)+(|T1-TR|+|P1-MR|+|B1-BR|) (|T1-B1|+|T2-B2|+|TL-BL|)+(|TL-T2|+|ML-P2|+|BL-B2|) ]
    
    PSLLDQ XMM7, 8      ; XMM7  <- [ |T2-B2| 0 ]
    PADDSW XMM15, XMM7  ; XMM15 <- [ (|T2-B2|+|TR-BR|+|T1-B1|)+(|T1-TR|+|P1-MR|+|B1-BR|) (|T1-B1|+|T2-B2|+|TL-BL|)+(|TL-T2|+|ML-P2|+|BL-B2|) ]

    PACKUSWB XMM15, XMM15

    MOVDQA XMM10, [MASK_OR]
    POR XMM15, XMM10    ; XMM15 <- [ X X X X X X X X FF P2R P2G P2B FF P1R P1G P1B ]

    MOVQ [R12], XMM15

    INC RCX
    INC R13
    ADD R12, 8
    ADD RBX, 8
    CMP RCX, R15
    JE .bordeBlanco
    CMP R13, R14
    JNE .loop
    MOV R13, 0
    ADD R12, 8
    ADD RBX, 8
    JMP .loop

.bordeBlanco:
    MOV RBX, R11
    MOV RCX, 0
.loopPrimeraFila:
    MOV qword[RBX], -1
    ADD RBX, 8
    ADD RCX, 2
    CMP RCX, R8
    JL .loopPrimeraFila

    SUB R10, 2
    MOV RCX, 0
.loopCostados:
    MOV dword[RBX], -1
    MOV R9, R8
    DEC R9
    LEA RBX, [RBX+4*R9]
    MOV dword[RBX], -1
    ADD RBX, 4
    INC RCX
    CMP RCX, R10
    JL .loopCostados

    MOV RCX, 0
.loopUltimaFila:
    MOV qword[RBX], -1
    ADD RBX, 8
    ADD RCX, 2
    CMP RCX, R8
    JL .loopUltimaFila

    ADD RSP, 8
    POP R15
    POP R14
    POP R13
    POP R12
    POP RBX
    POP RBP
    RET