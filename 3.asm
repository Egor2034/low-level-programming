%include "io64.inc"

; log_2(tg(x/a)) = 2b
; x = a * arctg(2^(2b))

section .text
global main
main:
    push rbp
    mov rbp, rsp
    sub rsp, 24
    
    ; [rbp - 4] a = 2.0
    ; [rbp - 8] b = 0.5
    ; [rbp - 12] x
    
    mov dword [rbp - 4], 0x40000000
    mov dword [rbp - 8], 0x3f000000
    
    fld dword [rbp - 8]
    fadd st0, st0 ; st0 = 2b
    
    ;2^(2b)
    fld st0 ; st0 = 1.0
    frndint 
    fsub st1, st0 ; st1 = st1 - st0
    fxch st1 ; st0 <-> st1
    f2xm1 
    fld1
    faddp st1, st0         
    fxch st1               
    fscale                 
    fstp st1 ; st0 = 2^(2b) 
    
    fld1
    fpatan ; st0 = arctg(2^(2b))
    
    fld dword [rbp - 4] 
    fmulp st1, st0 ; st0 = a * arctg(2^(2b))
    
    fst dword [rbp - 12]
    
    mov rsp, rbp
    pop rbp
    xor eax, eax
    ret