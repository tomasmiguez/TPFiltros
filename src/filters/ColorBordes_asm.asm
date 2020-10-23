extern ColorBordes_c
global ColorBordes_asm

section .rodata

ALIGN 16

MASK_OR: DB 0, 0, 0, 255, 0, 0, 0, 255

PIXEL_BLANCO: DB 255, 255, 255, 255

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
    MOV R14, RDX    ; R14 <- width-1
    DEC R14
    MOV R15, RCX    ; R15 <- height-1
    DEC R14

    MOV R10, RBX    ; Puntero a la posicion actual de src
    MOV R11, R12    ; Puntero a la posicion actual del resultado    

    MOV RCX, 1      ; Contador de altura i
.loopAltura:
    
    MOV R13, 1      ; Contador de ancho j
.loopAncho:

    MOV R9, 0
    MOV R9, R8         ; R9 <- width
    LEA R9, [4*R9]      ; R9 <- 4*width
    MOV EAX, ECX
    DEC EAX
    MUL R9D
    MOV R9, RAX         ; R9 <- 4*width*(i-1)
    MOV RAX, R13
    DEC RAX
    LEA R9, [R9+4*RAX]  ; R9 <- 4*(width*(i-1)+(j-1))
    ADD R9, RBX         ; R9 <- src+4*(width*(i-1)+(j-1))

    ; Vamos a guardar los 8 bits de resultado aca, lo empezamos en 0
    PANDN XMM15, XMM15  ; XMM0 <- [0 0 0 0 0 0 0 0]

    MOVDQU XMM0, [R9]   ; XMM0 <- [ T1A T1R T1G T1B TLA TLR TLG TLB ]
    ADD R9, 16
    MOVDQU XMM1, [R9]   ; XMM1 <- [ TRA TRR TRG TRB T2A T2R T2G T2B ]
    LEA R9, [R9+4*R8]
    MOVDQU XMM3, [R9]   ; XMM3 <- [ MRA MRR MRG MRB P2A P2R P2G P2B ]
    SUB R9, 16
    MOVDQU XMM2, [R9]   ; XMM2 <- [ P1A P1R P1G P1B MLA MLR MLG MLB ]
    LEA R9, [R9+4*R8]
    MOVDQU XMM4, [R9]   ; XMM4 <- [ B1A B1R B1G B1B BLA BLR BLG BLB ]
    ADD R9, 16
    MOVDQU XMM5, [R9]   ; XMM5 <- [ BRA BRR BRG BRB B2A B2R B2G B2B ]

    MOVDQA XMM6, XMM0   ; XMM6  <- [ T1 TL ]
    PSUBB XMM6, XMM1    ; XMM6  <- [ T1-TR TL-T2 ]
    PABSB XMM6, XMM6    ; XMM6  <- [ |T1-TR| |TL-T2| ]
    MOVDQA XMM15, XMM6  ; XMM15 <- [ |T1-TR| |TL-T2| ]
 
    MOVDQA XMM7, XMM2   ; XMM7  <- [ P1 ML ]
    PSUBB XMM7, XMM3    ; XMM7  <- [ P1-MR ML-P2 ]
    PABSB XMM7, XMM7    ; XMM6  <- [ |P1-MR| |ML-P2| ]
    PADDSB XMM15, XMM7  ; XMM15 <- [ |T1-TR|+|P1-MR| |TL-T2|+|ML-P2| ]

    MOVDQA XMM8, XMM4   ; XMM8  <- [ B1 BL ]
    PSUBB XMM8, XMM5    ; XMM8  <- [ B1-BR BL-B2]
    PABSB XMM8, XMM8    ; XMM8  <- [ |B1-BR| |BL-B2| ]
    PADDSB XMM15, XMM8  ; XMM15 <- [ |T1-TR|+|P1-MR|+|B1-BR| |TL-T2|+|ML-P2|+|BL-B2| ]
    
    MOVDQA XMM6, XMM0   ; XMM6  <- [ T1 TL ]
    PSUBB XMM6, XMM4     ; XMM6  <- [ T1-B1 TL-BL ]
    PABSB XMM6, XMM6    ; XMM6  <- [ |T1-B1| |TL-BL| ]
    PADDSB XMM15, XMM6  ; XMM15 <- [ (|T1-B1|)+(|T1-TR|+|P1-MR|+|B1-BR|) (|TL-BL|)+(|TL-T2|+|ML-P2|+|BL-B2|) ]

    MOVDQA XMM7, XMM1   ; XMM7  <- [ TR T2 ]
    PSUBB XMM7, XMM5     ; XMM7  <- [ TR-BR T2-B2 ]
    PABSB XMM7, XMM7    ; XMM7  <- [ |TR-BR| |T2-B2| ]
    PADDSB XMM15, XMM6  ; XMM15 <- [ (|TR-BR|+|T1-B1|)+(|T1-TR|+|P1-MR|+|B1-BR|) (|T2-B2|+|TL-BL|)+(|TL-T2|+|ML-P2|+|BL-B2|) ]

    PSRLDQ XMM6, 8      ; XMM6  <- [ 0 |T1-B1| ]
    PADDSB XMM15, XMM6  ; XMM15 <- [ (|TR-BR|+|T1-B1|)+(|T1-TR|+|P1-MR|+|B1-BR|) (|T1-B1|+|T2-B2|+|TL-BL|)+(|TL-T2|+|ML-P2|+|BL-B2|) ]
    
    PSLLDQ XMM7, 8      ; XMM7  <- [ |T2-B2| 0 ]
    PADDSB XMM15, XMM7  ; XMM15 <- [ (|T2-B2|+|TR-BR|+|T1-B1|)+(|T1-TR|+|P1-MR|+|B1-BR|) (|T1-B1|+|T2-B2|+|TL-BL|)+(|TL-T2|+|ML-P2|+|BL-B2|) ]

    MOVDQA XMM10, [MASK_OR]
    POR XMM15, XMM10    ; XMM15 <- [ FF x x x FF x x x ]

    MOVDQU [R12], XMM15

    ADD R12, 16
    ADD R13, 2
    CMP R13, R14
    JNE .loopAncho
    INC RCX
    CMP RCX, R15
    JMP .endLoop
    JMP .loopAltura

.endLoop:

    ADD RSP, 8
    POP R15
    POP R14
    POP R13
    POP R12
    POP RBX
    POP RBP
    RET