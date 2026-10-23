%include "io64.inc"

section .rodata
    zero: dd 0.0

section .text
global main
main:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    
    ; [rbp - 16] vec_a
    ; [rbp - 32] vec_b
    ; [rbp - 36] res_scalar
    ; [rbp - 40] res_vector 
    
    mov dword [rbp - 16], 0x3f800000
    mov dword [rbp - 12], 0x40000000
    mov dword [rbp - 8], 0x40400000
    mov dword [rbp - 4], 0x40800000
    
    mov dword [rbp - 32], 0x40a00000
    mov dword [rbp - 28], 0x40c00000
    mov dword [rbp - 24], 0x40e00000
    mov dword [rbp - 20], 0x41000000
    
    ; Скалярный режим
    movss xmm0, [zero]
    movss xmm1, [zero]
    movss xmm2, [zero]
    
    xor rcx, rcx ; i
    
.scalar_loop:
    lea rdx, [rbp - 16]
    movss xmm3, [rdx + rcx*4] ; vec_a[i]
    lea rdx, [rbp - 32]
    movss xmm4, [rdx + rcx*4] ; vec_b[i]
    
    movss xmm5, xmm3
    mulss xmm5, xmm4
    addss xmm0, xmm5 ; xmm0 += vec_a[i] * vec_b[i]
    
    mulss xmm3, xmm3
    addss xmm1, xmm3 ; xmm1 += vec_a[i]^2
    
    mulss xmm4, xmm4
    addss xmm2, xmm4 ; xmm2 += vec_b[i]^2
    
    inc rcx
    cmp rcx, 4
    jl .scalar_loop
    
    sqrtss xmm1, xmm1 ; xmm1 = sqrt(xmm1)
    sqrtss xmm2, xmm2 ; xmm2 = sqrt(xmm2)
    mulss xmm1, xmm2 ; xmm1 = xmm1 * xmm2
    
    divss xmm0, xmm1 ; xmm0 = xmm0 / xmm1
    movss [rbp - 36], xmm0
    
    ; Векторный режим
    movaps xmm6, [rbp - 16] ; vec_a
    movaps xmm7, [rbp - 32] ; vec_b
    
    movaps xmm8, xmm6
    mulps xmm8, xmm7 ; a1*b1 | a2*b2 | a3*b3 | a4*b4
    haddps xmm8, xmm8   
    haddps xmm8, xmm8
    
    mulps xmm6, xmm6 ; a1*a1 | a2*a2 | a3*a3 | a4*a4
    mulps xmm7, xmm7 ; b1*b1 | b2*b2 | b3*b3 | b4*b4
    haddps xmm6, xmm6
    haddps xmm6, xmm6
    haddps xmm7, xmm7
    haddps xmm7, xmm7
    
    sqrtss xmm6, xmm6 ; xmm6 = sqrt(xmm6)
    sqrtss xmm7, xmm7 ; xmm7 = sqrt(xmm7)
    mulss xmm6, xmm7
    divss xmm8, xmm6
    
    movss [rbp - 40], xmm8
    
    mov rsp, rbp
    pop rbp
    xor eax, eax
    ret