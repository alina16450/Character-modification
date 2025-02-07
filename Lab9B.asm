bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
                          extern scanf, printf, gets
                          import printf msvcrt.dll
                          import scanf msvcrt.dll
                          import gets msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    s resb 30
    c1 resb 1
    c2 resb 1
    
    formatPrint db 'Enter a sentence: ', 0
    formatAskForChar db 'Enter the character to replace, and the one to replace it with: ', 0
    formatPrintFinal db 'The changed sentence is: %s', 0
    
    
    formatRead db '%c %c', 0

; our code starts here
segment code use32 class=code
    start:
        ;b) 5
        
        push formatPrint
        call [printf]
        add esp, 4*1
        
        push dword s
        call [gets]
        add esp, 4*1
        
        push dword formatAskForChar
        call[printf]
        add esp, 4*1
        
        push dword c2
        push dword c1
        push dword formatRead
        call[scanf]
        add esp, 4*3
        
        mov ecx, 30
        mov esi, 0
        mov bl, byte[c2]
        
        repeat:
            mov al, [s+esi]
            cmp al, [c1]
            je replace
            jne final
            
            replace:
                mov [s+esi], bl
                
            final:
                inc esi
                
        loop repeat
        
        push dword s
        push dword formatPrintFinal
        call[printf]
        add esi, 4*2

        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
