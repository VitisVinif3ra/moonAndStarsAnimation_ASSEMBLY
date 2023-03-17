.ifndef clouds_s
.equ clouds_s,	0

.equ RESERVED_MEM,  40

    /* 
    * Input : 
    *   - x1 : x coordinate of center of cloud     
    *   - x2 : y coordinate of center of cloud
    *   - x11 : size of cloud
    *   - x10 : "brush" color
    */

draw_cloud1:
    sub sp, sp, RESERVED_MEM
    stur lr, [sp]
    stur x1, [sp, #8]
    stur x2, [sp, #16]
    stur x3, [sp, #24]
    stur x4, [sp, #32]
// Color:
    //movz x10, 0x60, lsl 16	
	//movk x10, 0x6061, lsl 00
//Forma:
	bl filled_circle

    mov x12, 4
    mov x13, 5
    mov x14, 3

    sdiv x17, x11, x13
    add x2, x2, x17

    mul x17, x11, x12
    sdiv x17, x17, x13
    add x1, x1, x17
    
    mul x11, x11, x12
    udiv x11, x11, x13
	bl filled_circle

    sub x1, x1, x17
    sub x1, x1, x17
    bl filled_circle

    ldur lr, [sp]
    ldur x1, [sp, #8]
    ldur x2, [sp, #16]
    ldur x8, [sp, #24]
    ldur x9, [sp, #32]
    add sp, sp, RESERVED_MEM
    br lr

draw_cloud2:
    sub sp, sp, RESERVED_MEM
    stur lr, [sp]
    stur x1, [sp, #8]
    stur x2, [sp, #16]
    stur x3, [sp, #24]
    stur x4, [sp, #32]

// Color:
    //movz x10, 0x60, lsl 16	
	//movk x10, 0x6061, lsl 00
//Forma:
	bl filled_circle
    
    mov x12, 4
    mov x13, 5
    mov x14, 3

    mul x17, x11, x14
    sdiv x17, x17, x12
    add x1, x1, x17

    sdiv x17, x11, x13
    add x2, x2, x17
    
    mul x11, x11, x12
    udiv x11, x11, x13
	bl filled_circle
    
    mul x17, x11, x14
    sdiv x17, x17, x12
    add x1, x1, x17

    sdiv x17, x11, x13
    add x2, x2, x17

    mul x11, x11, x12
    udiv x11, x11, x13
	bl filled_circle

    mul x17, x11, x14
    sdiv x17, x17, x12
    add x1, x1, x17
    
    sdiv x17, x11, x13
    add x2, x2, x17
    
    mul x11, x11, x12
    udiv x11, x11, x13
	bl filled_circle

    ldur lr, [sp]
    ldur x1, [sp, #8]
    ldur x2, [sp, #16]
    ldur x8, [sp, #24]
    ldur x9, [sp, #32]
    add sp, sp, RESERVED_MEM
    br lr 

.endif
