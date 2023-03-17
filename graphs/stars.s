.ifndef stars_s
.equ stars_s,	0

.text
stars:
    sub sp, sp, 40
    stur lr, [sp]
    stur x1, [sp,#8]
    stur x2, [sp,#16]
    stur x6, [sp,#24]
    stur x10,[sp,#32]
    /*
    * Input:
    *   - x6 : Size of stars
    */ 
    lsr x6, x6, 1
    add x11, x6, 6

// Halo
    movz x10, 0x05DD, lsl 16	
	movk x10, 0xDDDD, lsl 00	// Set color to White

    mov x1, #600
    mov x2, #80  
    bl filled_circle

    mov x1, #525
    mov x2, #333
    bl filled_circle

    mov x1, #475
    mov x2, #444
    bl filled_circle

    mov x1, #555
    mov x2, #412
    bl filled_circle

    mov x1, #50
    mov x2, #195
    bl filled_circle

    mov x1, #479
    mov x2, #360  
    bl filled_circle

    mov x1, #439
    mov x2, #330  
    bl filled_circle

    mov x1, #516
    mov x2, #300  
    bl filled_circle

    mov x1, #500
    mov x2, #180  
    bl filled_circle

    mov x1, #110
    mov x2, #30 
    bl filled_circle

    mov x1, #500
    mov x2, #30 
    bl filled_circle

    mov x1, #620
    mov x2, #250
    bl filled_circle

 // OrionConstellation:
    mov x1, #48
    mov x2, #290  
    bl filled_circle

    mov x1, #60
    mov x2, #280  
    bl filled_circle

    mov x1, #75
    mov x2, #350
    bl filled_circle

    mov x1, #90
    mov x2, #345
    bl filled_circle

    mov x1, #110
    mov x2, #357
    bl filled_circle

    mov x1, #148
    mov x2, #365
    bl filled_circle

    mov x1, #155
    mov x2, #330
    bl filled_circle

    mov x1, #205
    mov x2, #320
    bl filled_circle

    mov x1, #208
    mov x2, #260
    bl filled_circle

    mov x1, #229
    mov x2, #480
    bl filled_circle

    mov x1, #235
    mov x2, #380
    bl filled_circle

    mov x1, #248
    mov x2, #360
    bl filled_circle

    mov x1, #248
    mov x2, #270
    bl filled_circle

    mov x1, #270
    mov x2, #300
    bl filled_circle

    mov x1, #272
    mov x2, #315
    bl filled_circle

    mov x1, #288
    mov x2, #461
    bl filled_circle

    mov x1, #350
    mov x2, #358  
    bl filled_circle

    ldur x10, [sp, 32]

// Stars
    mov x1, #600
    mov x2, #80  
    bl draw_em

    mov x1, #525
    mov x2, #333
    bl draw_em

    mov x1, #475
    mov x2, #444
    bl draw_em

    mov x1, #555
    mov x2, #412
    bl draw_em

    mov x1, #50
    mov x2, #195
    bl draw_em

    mov x1, #479
    mov x2, #360  
    bl draw_em

    mov x1, #439
    mov x2, #330  
    bl draw_em

    mov x1, #516
    mov x2, #300  
    bl draw_em

    mov x1, #500
    mov x2, #180  
    bl draw_em

    mov x1, #110
    mov x2, #30 
    bl draw_em

    mov x1, #500
    mov x2, #30 
    bl draw_em

    mov x1, #620
    mov x2, #250
    bl draw_em

 // OrionConstellation:
    mov x1, #48
    mov x2, #290  
    bl draw_em

    mov x1, #60
    mov x2, #280  
    bl draw_em

    mov x1, #75
    mov x2, #350
    bl draw_em

    mov x1, #90
    mov x2, #345
    bl draw_em

    mov x1, #110
    mov x2, #357
    bl draw_em

    mov x1, #148
    mov x2, #365
    bl draw_em

    mov x1, #155
    mov x2, #330
    bl draw_em

    mov x1, #205
    mov x2, #320
    bl draw_em

    mov x1, #208
    mov x2, #260
    bl draw_em

    mov x1, #229
    mov x2, #480
    bl draw_em

    mov x1, #235
    mov x2, #380
    bl draw_em

    mov x1, #248
    mov x2, #360
    bl draw_em

    mov x1, #248
    mov x2, #270
    bl draw_em

    mov x1, #270
    mov x2, #300
    bl draw_em

    mov x1, #272
    mov x2, #315
    bl draw_em

    mov x1, #288
    mov x2, #461
    bl draw_em

    mov x1, #350
    mov x2, #358  
    bl draw_em

/*
* Output:
*   -
*/
    ldur x10,[sp,#32]
    ldur x6, [sp,#24]
    ldur x2, [sp,#16]
    ldur x1, [sp,#8]
    ldur lr, [sp]
    add sp, sp, 40
br lr

draw_em:
    sub sp, sp, 24
    stur lr, [sp]
    stur x16, [sp,#8]
    stur x17, [sp, #16]
    /*
    * Input:
    *   - x1, x2 : x,y coordinates center of star
    *   - x6 : Size of star
    */
    add x16, x1, x6
    add x17, x2, x6
    bl line
    add x16, x1, xzr
    add x17, x2, x6
    bl line
    add x16, x1, x6
    add x17, x2, xzr
    bl line
    add x16, x1, x6
    sub x17, x2, x6
    bl line     
    add x16, x1, xzr
    sub x17, x2, x6
    bl line     
    sub x16, x1, x6
    add x17, x2, x6
    bl line 
    sub x16, x1, x6
    add x17, x2, xzr
    bl line     
    sub x16, x1, x6
    sub x17, x2, x6
    bl line 
    /*
    * Output:
    *   - Paints a star to screen
    */
    ldur x17, [sp, #16]
    ldur x16, [sp,#8]
    ldur lr, [sp]
    add sp, sp, 24
    br lr

.endif
