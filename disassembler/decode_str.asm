; This file is auto-generated by codegen. Don't modify it directly
; Either modify the opcode db or the generation logic in codegen
; These strings are used by the disassembler (produced by -s)

	; opcode strings
	.a00 db "NOP    ",0
	.a01 db "LD     BC, 0x%02x%02x",0
	.a02 db "LD     (BC), A",0
	.a03 db "INC    BC",0
	.a04 db "INC    B",0
	.a05 db "DEC    B",0
	.a06 db "LD     B, 0x%02x",0
	.a07 db "RLCA   ",0
	.a08 db "LD     (0x%02x%02x), SP",0
	.a09 db "ADD    HL, BC",0
	.a0a db "LD     A, (BC)",0
	.a0b db "DEC    BC",0
	.a0c db "INC    C",0
	.a0d db "DEC    C",0
	.a0e db "LD     C, 0x%02x",0
	.a0f db "RRCA   ",0
	.a10 db "STOP   0",0
	.a11 db "LD     DE, 0x%02x%02x",0
	.a12 db "LD     (DE), A",0
	.a13 db "INC    DE",0
	.a14 db "INC    D",0
	.a15 db "DEC    D",0
	.a16 db "LD     D, 0x%02x",0
	.a17 db "RLA    ",0
	.a18 db "JR     0x%02x",0
	.a19 db "ADD    HL, DE",0
	.a1a db "LD     A, (DE)",0
	.a1b db "DEC    DE",0
	.a1c db "INC    E",0
	.a1d db "DEC    E",0
	.a1e db "LD     E, 0x%02x",0
	.a1f db "RRA    ",0
	.a20 db "JR     NZ, 0x%02x",0
	.a21 db "LD     HL, 0x%02x%02x",0
	.a22 db "LD     (HL+), A",0
	.a23 db "INC    HL",0
	.a24 db "INC    H",0
	.a25 db "DEC    H",0
	.a26 db "LD     H, 0x%02x",0
	.a27 db "DAA    ",0
	.a28 db "JR     Z, 0x%02x",0
	.a29 db "ADD    HL, HL",0
	.a2a db "LD     A, (HL+)",0
	.a2b db "DEC    HL",0
	.a2c db "INC    L",0
	.a2d db "DEC    L",0
	.a2e db "LD     L, 0x%02x",0
	.a2f db "CPL    ",0
	.a30 db "JR     NC, 0x%02x",0
	.a31 db "LD     SP, 0x%02x%02x",0
	.a32 db "LD     (HL-), A",0
	.a33 db "INC    SP",0
	.a34 db "INC    (HL)",0
	.a35 db "DEC    (HL)",0
	.a36 db "LD     (HL), 0x%02x",0
	.a37 db "SCF    ",0
	.a38 db "JR     C, 0x%02x",0
	.a39 db "ADD    HL, SP",0
	.a3a db "LD     A, (HL-)",0
	.a3b db "DEC    SP",0
	.a3c db "INC    A",0
	.a3d db "DEC    A",0
	.a3e db "LD     A, 0x%02x",0
	.a3f db "CCF    ",0
	.a40 db "LD     B, B",0
	.a41 db "LD     B, C",0
	.a42 db "LD     B, D",0
	.a43 db "LD     B, E",0
	.a44 db "LD     B, H",0
	.a45 db "LD     B, L",0
	.a46 db "LD     B, (HL)",0
	.a47 db "LD     B, A",0
	.a48 db "LD     C, B",0
	.a49 db "LD     C, C",0
	.a4a db "LD     C, D",0
	.a4b db "LD     C, E",0
	.a4c db "LD     C, H",0
	.a4d db "LD     C, L",0
	.a4e db "LD     C, (HL)",0
	.a4f db "LD     C, A",0
	.a50 db "LD     D, B",0
	.a51 db "LD     D, C",0
	.a52 db "LD     D, D",0
	.a53 db "LD     D, E",0
	.a54 db "LD     D, H",0
	.a55 db "LD     D, L",0
	.a56 db "LD     D, (HL)",0
	.a57 db "LD     D, A",0
	.a58 db "LD     E, B",0
	.a59 db "LD     E, C",0
	.a5a db "LD     E, D",0
	.a5b db "LD     E, E",0
	.a5c db "LD     E, H",0
	.a5d db "LD     E, L",0
	.a5e db "LD     E, (HL)",0
	.a5f db "LD     E, A",0
	.a60 db "LD     H, B",0
	.a61 db "LD     H, C",0
	.a62 db "LD     H, D",0
	.a63 db "LD     H, E",0
	.a64 db "LD     H, H",0
	.a65 db "LD     H, L",0
	.a66 db "LD     H, (HL)",0
	.a67 db "LD     H, A",0
	.a68 db "LD     L, B",0
	.a69 db "LD     L, C",0
	.a6a db "LD     L, D",0
	.a6b db "LD     L, E",0
	.a6c db "LD     L, H",0
	.a6d db "LD     L, L",0
	.a6e db "LD     L, (HL)",0
	.a6f db "LD     L, A",0
	.a70 db "LD     (HL), B",0
	.a71 db "LD     (HL), C",0
	.a72 db "LD     (HL), D",0
	.a73 db "LD     (HL), E",0
	.a74 db "LD     (HL), H",0
	.a75 db "LD     (HL), L",0
	.a76 db "HALT   ",0
	.a77 db "LD     (HL), A",0
	.a78 db "LD     A, B",0
	.a79 db "LD     A, C",0
	.a7a db "LD     A, D",0
	.a7b db "LD     A, E",0
	.a7c db "LD     A, H",0
	.a7d db "LD     A, L",0
	.a7e db "LD     A, (HL)",0
	.a7f db "LD     A, A",0
	.a80 db "ADD    A, B",0
	.a81 db "ADD    A, C",0
	.a82 db "ADD    A, D",0
	.a83 db "ADD    A, E",0
	.a84 db "ADD    A, H",0
	.a85 db "ADD    A, L",0
	.a86 db "ADD    A, (HL)",0
	.a87 db "ADD    A, A",0
	.a88 db "ADC    A, B",0
	.a89 db "ADC    A, C",0
	.a8a db "ADC    A, D",0
	.a8b db "ADC    A, E",0
	.a8c db "ADC    A, H",0
	.a8d db "ADC    A, L",0
	.a8e db "ADC    A, (HL)",0
	.a8f db "ADC    A, A",0
	.a90 db "SUB    B",0
	.a91 db "SUB    C",0
	.a92 db "SUB    D",0
	.a93 db "SUB    E",0
	.a94 db "SUB    H",0
	.a95 db "SUB    L",0
	.a96 db "SUB    (HL)",0
	.a97 db "SUB    A",0
	.a98 db "SBC    A, B",0
	.a99 db "SBC    A, C",0
	.a9a db "SBC    A, D",0
	.a9b db "SBC    A, E",0
	.a9c db "SBC    A, H",0
	.a9d db "SBC    A, L",0
	.a9e db "SBC    A, (HL)",0
	.a9f db "SBC    A, A",0
	.aa0 db "AND    B",0
	.aa1 db "AND    C",0
	.aa2 db "AND    D",0
	.aa3 db "AND    E",0
	.aa4 db "AND    H",0
	.aa5 db "AND    L",0
	.aa6 db "AND    (HL)",0
	.aa7 db "AND    A",0
	.aa8 db "XOR    B",0
	.aa9 db "XOR    C",0
	.aaa db "XOR    D",0
	.aab db "XOR    E",0
	.aac db "XOR    H",0
	.aad db "XOR    L",0
	.aae db "XOR    (HL)",0
	.aaf db "XOR    A",0
	.ab0 db "OR     B",0
	.ab1 db "OR     C",0
	.ab2 db "OR     D",0
	.ab3 db "OR     E",0
	.ab4 db "OR     H",0
	.ab5 db "OR     L",0
	.ab6 db "OR     (HL)",0
	.ab7 db "OR     A",0
	.ab8 db "CP     B",0
	.ab9 db "CP     C",0
	.aba db "CP     D",0
	.abb db "CP     E",0
	.abc db "CP     H",0
	.abd db "CP     L",0
	.abe db "CP     (HL)",0
	.abf db "CP     A",0
	.ac0 db "RET    NZ",0
	.ac1 db "POP    BC",0
	.ac2 db "JP     NZ, 0x%02x%02x",0
	.ac3 db "JP     0x%02x%02x",0
	.ac4 db "CALL   NZ, 0x%02x%02x",0
	.ac5 db "PUSH   BC",0
	.ac6 db "ADD    A, 0x%02x",0
	.ac7 db "RST    00H",0
	.ac8 db "RET    Z",0
	.ac9 db "RET    ",0
	.aca db "JP     Z, 0x%02x%02x",0
	.acc db "CALL   Z, 0x%02x%02x",0
	.acd db "CALL   0x%02x%02x",0
	.ace db "ADC    A, 0x%02x",0
	.acf db "RST    08H",0
	.ad0 db "RET    NC",0
	.ad1 db "POP    DE",0
	.ad2 db "JP     NC, 0x%02x%02x",0
	.ad3 db "invalid  ",0
	.ad4 db "CALL   NC, 0x%02x%02x",0
	.ad5 db "PUSH   DE",0
	.ad6 db "SUB    0x%02x",0
	.ad7 db "RST    10H",0
	.ad8 db "RET    C",0
	.ad9 db "RETI   ",0
	.ada db "JP     C, 0x%02x%02x",0
	.adb db "invalid  ",0
	.adc db "CALL   C, 0x%02x%02x",0
	.add db "invalid  ",0
	.ade db "SBC    A, 0x%02x",0
	.adf db "RST    18H",0
	.ae0 db "LDH    (0x%02x), A",0
	.ae1 db "POP    HL",0
	.ae2 db "LD     (C), A",0
	.ae3 db "invalid  ",0
	.ae4 db "invalid  ",0
	.ae5 db "PUSH   HL",0
	.ae6 db "AND    0x%02x",0
	.ae7 db "RST    20H",0
	.ae8 db "ADD    SP, 0x%02x",0
	.ae9 db "JP     (HL)",0
	.aea db "LD     (0x%02x%02x), A",0
	.aeb db "invalid  ",0
	.aec db "invalid  ",0
	.aed db "invalid  ",0
	.aee db "XOR    0x%02x",0
	.aef db "RST    28H",0
	.af0 db "LDH    A, (0x%02x)",0
	.af1 db "POP    AF",0
	.af2 db "LD     A, (C)",0
	.af3 db "DI     ",0
	.af4 db "invalid  ",0
	.af5 db "PUSH   AF",0
	.af6 db "OR     0x%02x",0
	.af7 db "RST    30H",0
	.af8 db "LD     HL, SP+0x%02x",0
	.af9 db "LD     SP, HL",0
	.afa db "LD     A, (0x%02x%02x)",0
	.afb db "EI     ",0
	.afc db "invalid  ",0
	.afd db "invalid  ",0
	.afe db "CP     0x%02x",0
	.aff db "RST    38H",0
	
	; opcode with prefix 0xCB strings
	.b00 db "RLC    B",0
	.b01 db "RLC    C",0
	.b02 db "RLC    D",0
	.b03 db "RLC    E",0
	.b04 db "RLC    H",0
	.b05 db "RLC    L",0
	.b06 db "RLC    (HL)",0
	.b07 db "RLC    A",0
	.b08 db "RRC    B",0
	.b09 db "RRC    C",0
	.b0a db "RRC    D",0
	.b0b db "RRC    E",0
	.b0c db "RRC    H",0
	.b0d db "RRC    L",0
	.b0e db "RRC    (HL)",0
	.b0f db "RRC    A",0
	.b10 db "RL     B",0
	.b11 db "RL     C",0
	.b12 db "RL     D",0
	.b13 db "RL     E",0
	.b14 db "RL     H",0
	.b15 db "RL     L",0
	.b16 db "RL     (HL)",0
	.b17 db "RL     A",0
	.b18 db "RR     B",0
	.b19 db "RR     C",0
	.b1a db "RR     D",0
	.b1b db "RR     E",0
	.b1c db "RR     H",0
	.b1d db "RR     L",0
	.b1e db "RR     (HL)",0
	.b1f db "RR     A",0
	.b20 db "SLA    B",0
	.b21 db "SLA    C",0
	.b22 db "SLA    D",0
	.b23 db "SLA    E",0
	.b24 db "SLA    H",0
	.b25 db "SLA    L",0
	.b26 db "SLA    (HL)",0
	.b27 db "SLA    A",0
	.b28 db "SRA    B",0
	.b29 db "SRA    C",0
	.b2a db "SRA    D",0
	.b2b db "SRA    E",0
	.b2c db "SRA    H",0
	.b2d db "SRA    L",0
	.b2e db "SRA    (HL)",0
	.b2f db "SRA    A",0
	.b30 db "SWAP   B",0
	.b31 db "SWAP   C",0
	.b32 db "SWAP   D",0
	.b33 db "SWAP   E",0
	.b34 db "SWAP   H",0
	.b35 db "SWAP   L",0
	.b36 db "SWAP   (HL)",0
	.b37 db "SWAP   A",0
	.b38 db "SRL    B",0
	.b39 db "SRL    C",0
	.b3a db "SRL    D",0
	.b3b db "SRL    E",0
	.b3c db "SRL    H",0
	.b3d db "SRL    L",0
	.b3e db "SRL    (HL)",0
	.b3f db "SRL    A",0
	.b40 db "BIT    0, B",0
	.b41 db "BIT    0, C",0
	.b42 db "BIT    0, D",0
	.b43 db "BIT    0, E",0
	.b44 db "BIT    0, H",0
	.b45 db "BIT    0, L",0
	.b46 db "BIT    0, (HL)",0
	.b47 db "BIT    0, A",0
	.b48 db "BIT    1, B",0
	.b49 db "BIT    1, C",0
	.b4a db "BIT    1, D",0
	.b4b db "BIT    1, E",0
	.b4c db "BIT    1, H",0
	.b4d db "BIT    1, L",0
	.b4e db "BIT    1, (HL)",0
	.b4f db "BIT    1, A",0
	.b50 db "BIT    2, B",0
	.b51 db "BIT    2, C",0
	.b52 db "BIT    2, D",0
	.b53 db "BIT    2, E",0
	.b54 db "BIT    2, H",0
	.b55 db "BIT    2, L",0
	.b56 db "BIT    2, (HL)",0
	.b57 db "BIT    2, A",0
	.b58 db "BIT    3, B",0
	.b59 db "BIT    3, C",0
	.b5a db "BIT    3, D",0
	.b5b db "BIT    3, E",0
	.b5c db "BIT    3, H",0
	.b5d db "BIT    3, L",0
	.b5e db "BIT    3, (HL)",0
	.b5f db "BIT    3, A",0
	.b60 db "BIT    4, B",0
	.b61 db "BIT    4, C",0
	.b62 db "BIT    4, D",0
	.b63 db "BIT    4, E",0
	.b64 db "BIT    4, H",0
	.b65 db "BIT    4, L",0
	.b66 db "BIT    4, (HL)",0
	.b67 db "BIT    4, A",0
	.b68 db "BIT    5, B",0
	.b69 db "BIT    5, C",0
	.b6a db "BIT    5, D",0
	.b6b db "BIT    5, E",0
	.b6c db "BIT    5, H",0
	.b6d db "BIT    5, L",0
	.b6e db "BIT    5, (HL)",0
	.b6f db "BIT    5, A",0
	.b70 db "BIT    6, B",0
	.b71 db "BIT    6, C",0
	.b72 db "BIT    6, D",0
	.b73 db "BIT    6, E",0
	.b74 db "BIT    6, H",0
	.b75 db "BIT    6, L",0
	.b76 db "BIT    6, (HL)",0
	.b77 db "BIT    6, A",0
	.b78 db "BIT    7, B",0
	.b79 db "BIT    7, C",0
	.b7a db "BIT    7, D",0
	.b7b db "BIT    7, E",0
	.b7c db "BIT    7, H",0
	.b7d db "BIT    7, L",0
	.b7e db "BIT    7, (HL)",0
	.b7f db "BIT    7, A",0
	.b80 db "RES    0, B",0
	.b81 db "RES    0, C",0
	.b82 db "RES    0, D",0
	.b83 db "RES    0, E",0
	.b84 db "RES    0, H",0
	.b85 db "RES    0, L",0
	.b86 db "RES    0, (HL)",0
	.b87 db "RES    0, A",0
	.b88 db "RES    1, B",0
	.b89 db "RES    1, C",0
	.b8a db "RES    1, D",0
	.b8b db "RES    1, E",0
	.b8c db "RES    1, H",0
	.b8d db "RES    1, L",0
	.b8e db "RES    1, (HL)",0
	.b8f db "RES    1, A",0
	.b90 db "RES    2, B",0
	.b91 db "RES    2, C",0
	.b92 db "RES    2, D",0
	.b93 db "RES    2, E",0
	.b94 db "RES    2, H",0
	.b95 db "RES    2, L",0
	.b96 db "RES    2, (HL)",0
	.b97 db "RES    2, A",0
	.b98 db "RES    3, B",0
	.b99 db "RES    3, C",0
	.b9a db "RES    3, D",0
	.b9b db "RES    3, E",0
	.b9c db "RES    3, H",0
	.b9d db "RES    3, L",0
	.b9e db "RES    3, (HL)",0
	.b9f db "RES    3, A",0
	.ba0 db "RES    4, B",0
	.ba1 db "RES    4, C",0
	.ba2 db "RES    4, D",0
	.ba3 db "RES    4, E",0
	.ba4 db "RES    4, H",0
	.ba5 db "RES    4, L",0
	.ba6 db "RES    4, (HL)",0
	.ba7 db "RES    4, A",0
	.ba8 db "RES    5, B",0
	.ba9 db "RES    5, C",0
	.baa db "RES    5, D",0
	.bab db "RES    5, E",0
	.bac db "RES    5, H",0
	.bad db "RES    5, L",0
	.bae db "RES    5, (HL)",0
	.baf db "RES    5, A",0
	.bb0 db "RES    6, B",0
	.bb1 db "RES    6, C",0
	.bb2 db "RES    6, D",0
	.bb3 db "RES    6, E",0
	.bb4 db "RES    6, H",0
	.bb5 db "RES    6, L",0
	.bb6 db "RES    6, (HL)",0
	.bb7 db "RES    6, A",0
	.bb8 db "RES    7, B",0
	.bb9 db "RES    7, C",0
	.bba db "RES    7, D",0
	.bbb db "RES    7, E",0
	.bbc db "RES    7, H",0
	.bbd db "RES    7, L",0
	.bbe db "RES    7, (HL)",0
	.bbf db "RES    7, A",0
	.bc0 db "SET    0, B",0
	.bc1 db "SET    0, C",0
	.bc2 db "SET    0, D",0
	.bc3 db "SET    0, E",0
	.bc4 db "SET    0, H",0
	.bc5 db "SET    0, L",0
	.bc6 db "SET    0, (HL)",0
	.bc7 db "SET    0, A",0
	.bc8 db "SET    1, B",0
	.bc9 db "SET    1, C",0
	.bca db "SET    1, D",0
	.bcb db "SET    1, E",0
	.bcc db "SET    1, H",0
	.bcd db "SET    1, L",0
	.bce db "SET    1, (HL)",0
	.bcf db "SET    1, A",0
	.bd0 db "SET    2, B",0
	.bd1 db "SET    2, C",0
	.bd2 db "SET    2, D",0
	.bd3 db "SET    2, E",0
	.bd4 db "SET    2, H",0
	.bd5 db "SET    2, L",0
	.bd6 db "SET    2, (HL)",0
	.bd7 db "SET    2, A",0
	.bd8 db "SET    3, B",0
	.bd9 db "SET    3, C",0
	.bda db "SET    3, D",0
	.bdb db "SET    3, E",0
	.bdc db "SET    3, H",0
	.bdd db "SET    3, L",0
	.bde db "SET    3, (HL)",0
	.bdf db "SET    3, A",0
	.be0 db "SET    4, B",0
	.be1 db "SET    4, C",0
	.be2 db "SET    4, D",0
	.be3 db "SET    4, E",0
	.be4 db "SET    4, H",0
	.be5 db "SET    4, L",0
	.be6 db "SET    4, (HL)",0
	.be7 db "SET    4, A",0
	.be8 db "SET    5, B",0
	.be9 db "SET    5, C",0
	.bea db "SET    5, D",0
	.beb db "SET    5, E",0
	.bec db "SET    5, H",0
	.bed db "SET    5, L",0
	.bee db "SET    5, (HL)",0
	.bef db "SET    5, A",0
	.bf0 db "SET    6, B",0
	.bf1 db "SET    6, C",0
	.bf2 db "SET    6, D",0
	.bf3 db "SET    6, E",0
	.bf4 db "SET    6, H",0
	.bf5 db "SET    6, L",0
	.bf6 db "SET    6, (HL)",0
	.bf7 db "SET    6, A",0
	.bf8 db "SET    7, B",0
	.bf9 db "SET    7, C",0
	.bfa db "SET    7, D",0
	.bfb db "SET    7, E",0
	.bfc db "SET    7, H",0
	.bfd db "SET    7, L",0
	.bfe db "SET    7, (HL)",0
	.bff db "SET    7, A",0
	