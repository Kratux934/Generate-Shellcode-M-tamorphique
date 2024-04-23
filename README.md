# Projet de Shellcode Métamorphique x64

Ce projet vise à développer un shellcode métamorphique pour un reverse shell en architecture x64. L'objectif est de démontrer comment un shellcode peut être conçu pour changer dynamiquement de forme pour éviter la détection, tout en maintenant la fonctionnalité de base d'un reverse shell.

## Objectifs

- Comprendre et appliquer les principes de la programmation en assembleur x64.
- Développer un reverse shell basique en x64.
- Intégrer des techniques métamorphiques pour modifier la signature du shellcode à chaque exécution.
- Assurer la fonctionnalité dans des environnements contrôlés pour des fins éducatives et de recherche en sécurité.

## Prérequis

- NASM (Netwide Assembler) ou tout autre assembleur compatible x64.
- GDB (GNU Debugger) pour le débogage.
- Environnement virtuel (VM) ou conteneurs pour tester le shellcode de manière sécurisée.
- Connaissances de base en réseautique et en programmation système sous Linux ou Windows.

## Installation

Pour configurer votre environnement de développement :

```bash
# Installer NASM
sudo apt-get install nasm

# Installer GDB
sudo apt-get install gdb

# Configurer une machine virtuelle pour les tests
# Utilisez votre gestionnaire de VM préféré (ex. VirtualBox, VMware)
```

## Utilisation
Exemple de commande pour compiler et exécuter le shellcode:

```bash
# Compiler le shellcode
nasm -f elf64 -o output.o source.asm

# Lier le shellcode
ld output.o -o executable

# Exécuter le shellcode dans un environnement sécurisé
./executable
```

## Avertissements
Ce projet est destiné uniquement à des fins éducatives et de recherche en sécurité. L'utilisation de ce code dans un environnement de production ou malveillant est strictement interdite. Respectez toutes les lois locales et régulations lors de l'utilisation de ce code.
