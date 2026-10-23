%include "io64.inc"

; cos(x) = 1 - (x^2/2!) + (x^4/4!) - (x^6/6!)

section .rodata
    fact2: dd 2.0
    fact4: dd 24.0 
    fact6: dd 720.0
    
section .text
global main
main:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    
    ; [rbp - 4] - x = pi / 3 = 1.04719755
    ; [rbp - 8] - result 
    
    mov dword [rbp - 4], 0x3f860a92
    movss xmm0, [rbp - 4] ; x
    
    movss xmm1, xmm0
    mulss xmm1, xmm0 ; xmm1 = x^2
    
    movss xmm2, xmm1
    mulss xmm2, xmm1 ; xmm2 = x^4
    
    movss xmm3, xmm2
    mulss xmm3, xmm1 ; xmm3 = x^6
    
    divss xmm1, [fact2] ; xmm1 = (x^2/2)
    divss xmm2, [fact4] ; xmm2 = (x^4/24)
    divss xmm3, [fact6] ; xmm3 = (x^6/720)
    
    mov ecx, 1
    cvtsi2ss xmm4, ecx
    
    subss xmm4, xmm1
    addss xmm4, xmm2
    subss xmm4, xmm3
    
    movss [rbp - 8], xmm4
    
    mov rsp, rbp  
    pop rbp
    xor eax, eax
    ret
    