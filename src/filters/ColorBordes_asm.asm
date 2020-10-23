extern ColorBordes_c
global ColorBordes_asm

section .rodata

ALIGN 16

MASK_OR: DD 0xFF000000, 0xFF000000, 0xFF000000, 0xFF000000


section .text

; gdb --args ../build/tp2 ColorBordes -i asm ../img/Seven.bmp
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

    MOV R10, RBX    ; Puntero a src
    MOV R11, R12    ; Puntero a resultado    

    MOV RCX, 0      ; Contador de iteracion
    MOV R13, 0      ; Contador de iteracion en la fila

    LEA R12, [R12+4*R8]
    ADD R12, 4
.loop:
    MOV R9, RBX
    MOVDQU XMM0, [R9]   ; XMM0  <- [ TR T2 T1 TL ]
    LEA R9, [R9+4*R8]
    MOVDQU XMM1, [R9]   ; XMM1  <- [ MR P2 P1 ML ]
    LEA R9, [R9+4*R8]
    MOVDQU XMM2, [R9]   ; XMM2  <- [ BR B2 B1 BL ]

    MOVDQA XMM3, XMM0   ; XMM3  <- [ TR T2 T1 TL ]
    PSUBB XMM3, XMM2   ; XMM3  <- [ TR-BR T2-B2 T1-B1 TL-BL ]
    PABSB XMM3, XMM3    ; XMM3  <- [ |TR-BR| |T2-B2| |T1-B1| |TL-BL| ]

    MOVDQA XMM15, XMM3  ; XMM15 <- [ |TR-BR| |T2-B2| |T1-B1| |TL-BL| ]
    PSRLDQ XMM3, 4      ; XMM3  <- [ 0       |TR-BR| |T2-B2| |T1-B1| ]
    PADDSB XMM15, XMM3  ; XMM15 <- [ X X |T2-B2|+|T1-B1| |T1-B1|+|TL-BL| ]
    PSRLDQ XMM9, 4      ; XMM9  <- [ 0       0       |TR-BR| |T2-B2| ]
    PADDSB XMM15, XMM3  ; XMM15 <- [ X X |TR-BR|+|T2-B2|+|T1-B1| |T2-B2|+|T1-B1|+|TL-BL| ]

    MOVDQA XMM3, XMM0   ; XMM3  <- [ TR T2 T1 TL ]
    PSRLDQ XMM3, 8      ; XMM3  <- [ 0  0  TR T2 ]
    PSUBB XMM3, XMM0   ; XMM3  <- [ X X TR-T1 T2-TL ]
    PABSB XMM3, XMM3    ; XMM3  <- [ X X |TR-T1| |T2-TL| ]
    PADDSB XMM15, XMM3  ; XMM15 <- [ X X (|TR-T1|)+(|TR-BR|+|T2-B2|+|T1-B1|) (|T2-TL|)+(|T2-B2|+|T1-B1|+|TL-BL|) ]

    MOVDQA XMM3, XMM1   ; XMM3  <- []
    PSRLDQ XMM3, 8      ; XMM3  <- []
    PSUBB XMM3, XMM1   ; XMM3  <- []
    PABSB XMM3, XMM3    ; XMM3  <- []
    PADDSB XMM15, XMM3  ; XMM15 <- []

    MOVDQA XMM3, XMM2   ; XMM3  <- []
    PSRLDQ XMM3, 8      ; XMM3  <- []
    PSUBB XMM3, XMM2   ; XMM3  <- []
    PABSB XMM3, XMM3    ; XMM3  <- []
    PADDSB XMM15, XMM3  ; XMM15 <- []

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
    ;MOV qword[RBX], 0

    ADD RBX, 8
    INC RCX
    CMP RCX, R8
    JL .loopPrimeraFila

    ADD RSP, 8
    POP R15
    POP R14
    POP R13
    POP R12
    POP RBX
    POP RBP
    RET