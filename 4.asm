%include "io64.inc"

section .rodata
    epsilon: dd 0.00001

section .text
global main
main:
    push rbp
    mov rbp, rsp
    sub rsp, 24
    
    ; [rbp - 4] a = 0.0
    ; [rbp - 8] x = 2.0
    ; [rbp - 12] y = 0.0
    
    mov dword [rbp - 4],  0x00000000 
    mov dword [rbp - 8],  0x40000000 
    mov dword [rbp - 12], 0x00000000 
    
    ; z = a / x
    fld dword [rbp - 4] ; st0 = a
    fld dword [rbp - 8] ; st0 = x, st1 = a
    fdivp st1, st0 ; st0 = a / x = z
    
    ;   e^(2z). 
    fadd st0, st0 ; st0 = 2z
    fldl2e ; st0 = log2(e), st1 = 2z
    fmulp st1, st0 ; st0 = 2z * log2(e)
    
    fld st0                
    frndint
    fsub st1, st0 
    fxch st1 
    f2xm1 ; st0 = 2^(st0) - 1
    fld1
    faddp st1, st0 ; st0 = 2^(st0)
    fxch st1
    fscale ; st0 = 2^(st0) * 2^(st1) = e^(2z)
    fstp st1 ; st0 = e^(2z)
    
    ; th(z) = (e^(2z) - 1) / (e^(2z) + 1)
    fld st0
    fld1 ; st0 = 1, st1 = st2 = e^(2z)
    fsub st1, st0
    faddp st2, st0
    fdivrp st1, st0 
    
    fld dword [rbp - 12] ; st0 = y, st1 = th(a/x)
    fsubp st1, st0
    fabs
    
    fld dword [epsilon] 
    fcomip st1
    jnb .true 
    
    PRINT_DEC 4, 0
    jmp .exit
    
.true:
    PRINT_DEC 4, 1 
    
.exit:
    fstp st0
    mov rsp, rbp
    pop rbp
    xor eax, eax
    ret
