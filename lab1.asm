%include "io64.inc"

section .bss
    arr resd 100

section .text
global main

main:
    mov rbp, rsp
    
    ; [rbp - 8] : n (размер массива)
    ; [rbp - 16] : left (левая граница)
    ; [rbp - 24] : right (правая граница)
    ; [rbp - 32] : swapped (флаг перестановки)
    ; [rbp - 40] : temp (буфер для обмена элементов)
    ; [rbp - 48] : i (индекс для циклов)
        
    sub rsp, 48 ; 48 байт на стек
    
    push rbx
    push rsi
    push rdi
    
    PRINT_STRING "Enter array size: "
    GET_DEC 4, [rbp - 8] ; n
    NEWLINE
    
    mov dword [rbp - 48], 0 ; i = 0    
input_loop:
    mov ecx, [rbp - 48] ; в ecx i 
    cmp ecx, [rbp - 8] 
    jge input_done ; i >= n
    
    PRINT_STRING "Enter element: "
    GET_DEC 4, eax
    NEWLINE
    
    mov ecx, [rbp - 48]
    mov [arr + ecx * 4], eax
    
    inc dword [rbp - 48] ; i++
    jmp input_loop

input_done:
    mov dword [rbp - 16], 0 ; left = 0
    
    mov eax, [rbp - 8] ; n
    dec eax
    mov dword [rbp - 24], eax ; right = n - 1
    
    mov dword [rbp - 32], 1 ; swapped = 1
    
shaker_while:
    mov eax, [rbp - 32]
    cmp eax, 0
    je sorting_done
    
    mov dword [rbp - 32], 0 ; swapped = 0
    
    mov eax, [rbp - 16]
    mov dword [rbp - 48], eax
  
forward_for:
    mov eax, [rbp - 48]
    cmp eax, [rbp - 24]
    jge forward_for_end
    
    ; if (arr[i] > arr[i + 1])
    mov ecx, [rbp - 48] ; i
    mov eax, [arr + ecx * 4] ; arr[i]
    mov edx, [arr + ecx * 4 + 4] ; arr[i + 1]
    
    cmp eax, edx
    jle no_forward_swap 
    
    mov [rbp - 40], eax ; temp = arr[i]
    mov [arr + ecx * 4], edx ; arr[i] = arr[i + 1]
    mov eax, [rbp - 40]
    mov [arr + ecx * 4 + 4], eax ; arr[i + 1] = temp
    
    mov dword [rbp - 32], 1

no_forward_swap:
    inc dword [rbp - 48]
    jmp forward_for

forward_for_end:
    mov eax, [rbp - 32]
    cmp eax, 0 
    je sorting_done ; если swapped = 0

    mov dword [rbp - 32], 0
    dec dword [rbp - 24] ; right = right - 1
    
    mov eax, [rbp - 24]
    mov [rbp - 48], eax ; i = right
    
backward_for:
    mov eax, [rbp - 48]
    cmp eax, [rbp - 16]
    jle backward_for_end
    
    ; if (arr[i - 1] > arr[i])
    mov ecx, [rbp - 48]
    mov eax, [arr + ecx * 4 - 4] ; arr[i - 1]
    mov edx, [arr + ecx * 4] ; arr[i]
    
    cmp eax, edx
    jle no_backward_swap 
    
    mov [rbp - 40], eax ; temp = arr[i - 1]
    mov [arr + ecx * 4 - 4], edx ; arr[i - 1] = arr[i]
    mov eax, [rbp - 40]
    mov [arr + ecx * 4], eax ; arr[i] = temp
    
    mov dword [rbp - 32], 1 ; swapped = 1
    
no_backward_swap:
    dec dword [rbp - 48]
    jmp backward_for
    
backward_for_end:
    inc dword [rbp - 16] ; left++
    jmp shaker_while
    
sorting_done:
    
print_result:
    PRINT_STRING "Sorted array: "
    
    mov dword [rbp - 48], 0 ; i = 0
    
print_loop:
    mov ecx, [rbp - 48]
    cmp ecx, [rbp - 8]
    jge print_done
    
    PRINT_DEC 4, [arr + ecx * 4]
    PRINT_CHAR ' '
    
    inc dword [rbp - 48] ; i++
    jmp print_loop

print_done:
    NEWLINE
    
    pop rdi
    pop rsi
    pop rbx
    
    mov rsp, rbp
    xor eax, eax
    ret