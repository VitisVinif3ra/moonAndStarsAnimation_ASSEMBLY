.ifndef moon_s
.equ moon_s,	0

.equ RESERVED_MEM,  48

.equ MOON_MAIN_X,   320
.equ MOON_MAIN_Y,   100
.equ MOON_MAIN_RAD, 160

draw_moon:
    sub sp, sp, RESERVED_MEM
    stur lr, [sp]
    stur x1, [sp, #8]
    stur x2, [sp, #16]
    stur x8, [sp, #24]
    stur x9, [sp, #32]
    stur x27, [sp, #40]
	
    mov x9, MOON_MAIN_X
	mov x8, MOON_MAIN_Y
	
//---Halo---------------------------------------
    mov x1, x9
	mov x2, x8
    
    movz x10, 0x02EE, lsl 16	
	movk x10, 0xEEFF, lsl 00	// Set color to transparent white
    mov x11, MOON_MAIN_RAD
    add x11, x11, #30
    bl filled_circle

    movz x10, 0x02EE, lsl 16	
	movk x10, 0xEEFF, lsl 00	// Set color to transparent white
    mov x11, MOON_MAIN_RAD
    add x11, x11, #90
    bl filled_circle
    
//---Main body----------------------------------
    movz x10, 0x64E7, lsl 16	
	movk x10, 0xE9F7, lsl 00	// Set color to gray-er
    mov x11, MOON_MAIN_RAD
    bl filled_circle 

    mov x11, MOON_MAIN_RAD // Main body parameters
    sub x11, x11, #12
    movz x10, 0x64EE, lsl 16	
	movk x10, 0xF0FF, lsl 00	// Set color to gray-er
	bl filled_circle    // Main body
//---Craters - outer----------------------------
    movz x10, 0x64DE, lsl 16	
	movk x10, 0xDEF5, lsl 00	// Set color to gray-ish
    //-------------------------------------------
    add x1, x9, #0
	sub x2, x8, #60
	mov x11, #22  // Crater 1 parameters

    bl filled_circle
    //-------------------------------------------
    add x1, x9, #30
	sub x2, x8, #75
	mov x11, #20  // Crater 2 parameters

    bl filled_circle
    //-------------------------------------------
    sub x1, x9, #35
	sub x2, x8, #45
	mov x11, #24  // Crater 3 parameters

    bl filled_circle
    //-------------------------------------------
    sub x1, x9, #65
	add x2, x8, #0
	mov x11, #40  // Crater 3 parameters

    bl filled_circle
    //-------------------------------------------
    sub x1, x9, #73
	add x2, x8, #50
	mov x11, #40  // Crater 4 parameters

    bl filled_circle
    //-------------------------------------------
    sub x1, x9, #55
	add x2, x8, #60
	mov x11, #65  // Crater 5 parameters

    bl filled_circle
    //-------------------------------------------
    sub x1, x9, #100
	add x2, x8, #0
	mov x11, #40  // Crater 5 parameters

    bl filled_circle
    //-------------------------------------------
    sub x1, x9, #25
	sub x2, x8, #85
	mov x11, #20  // Crater 5 parameters

    bl filled_circle
    //-------------------------------------------
    add x1, x9, #10
	sub x2, x8, #90
	mov x11, #20  // Crater 5 parameters

    bl filled_circle
    //------------filled_circle-------------------------------
    sub x1, x9, #50
	sub x2, x8, #70
	mov x11, #20  // Crater 5 parameters

    bl filled_circle

//---Craters - inner----------------------------
    
    movz x10, 0x64DE, lsl 16	
	movk x10, 0xE2FF, lsl 00	// Set color to less gray-ish
    //-------------------------------------------
    add x1, x9, #0
	sub x2, x8, #60
	mov x11, #20  // Crater 1 parameters

    bl filled_circle
    //-------------------------------------------
    add x1, x9, #30
	sub x2, x8, #75
	mov x11, #18  // Crater 2 parameters

    bl filled_circle
    //-------------------------------------------
    sub x1, x9, #35
	sub x2, x8, #45
	mov x11, #22  // Crater 3 parameters

    bl filled_circle
    //-------------------------------------------
    sub x1, x9, #65
	add x2, x8, #0
	mov x11, #38  // Crater 3 parameters

    bl filled_circle
    //-------------------------------------------
    add x1, x9, #-73
	add x2, x8, #50
	mov x11, #38  // Crater 4 parameters

    bl filled_circle
    //-------------------------------------------
    sub x1, x9, #55
	add x2, x8, #60
	mov x11, #63  // Crater 5 parameters

    bl filled_circle
    //-------------------------------------------
    sub x1, x9, #100
	add x2, x8, #0
	mov x11, #38  // Crater 5 parameters

    bl filled_circle
    //-------------------------------------------
    sub x1, x9, #25
	sub x2, x8, #85
	mov x11, #18  // Crater 5 parameters

    bl filled_circle
    //-------------------------------------------
    add x1, x9, #10
	sub x2, x8, #90
	mov x11, #18  // Crater 5 parameters

    bl filled_circle
    //-------------------------------------------
    sub x1, x9, #50
	sub x2, x8, #70
	mov x11, #18  // Crater 5 parameters

    bl filled_circle

//---Shadow-------------------------------------
    mov x4, MOON_MAIN_X
    mov x5, MOON_MAIN_Y     // moon pos
    add x1, x4, #321
    mov x2, x5              // shadow pos
    mov x11, MOON_MAIN_RAD
    add x11, x11, #1

    lsr x8, x27, 2
    add x27, x8, x27
    sub x1, x1, x27         // shadow movement

    movz x10, 0x600F, lsl 16	
	movk x10, 0x0E2E, lsl 00	// Set color to transparent white

    bl circle_intersection 

    ldur lr, [sp]
    ldur x1, [sp, #8]
    ldur x2, [sp, #16]
    ldur x8, [sp, #24]
    ldur x9, [sp, #32]
    ldur x27, [sp, #40]
    add sp, sp, RESERVED_MEM
br lr

.endif
