.ifndef eclipse_s
.equ eclipse_s,	0

circle_intersection:
    sub sp, sp, #48
    stur lr, [sp]   // Saving return pointer
    stur x15, [sp,#8]  
    stur x16, [sp,#16]      
    stur x17, [sp,#24]   
    stur x21, [sp,#32] 
/*
*   - (x4,x5) center of moon
*   - (x1,x2) center of shadow
*   - x11 radius
*/
        // Initialize x21 = 2
        mov x21, #2
        // Initialize x16 = x11 and x17 = 0
        add x16, xzr, x11   // x = r
        add x17, xzr, xzr   // y = 0
        // Initialize P_1 to 1-r
        sub x15, xzr, x11   // x15 = -x11 = -r
        add x15, X15, #1    // x15 = -x11 + 1 = 1-r || P_1 = 1-r
    loop_inter:
        // Paint pixels
        bl shadow_octans
        // Decision tree
        mov x8, x16
        cmp x15, xzr
        B.LE inter_l1    // if P_k <= 0 then (x,y) = (x,y+1)
        B.GT inter_l2    // if P_k > 0 then (x,y) = (x-1,y+1)
    inter_l1:
        add x17, x17, #1 // y = y+1
        // Calculate P_k+1
        madd x15, x21, x17, x15  // P_k+1 = P_k + 2*((y_k) + 1)
        add x15, x15, #1        // P_k+1 = P_k + 2*((y_k) + 1) + 1
        B inter_end
    inter_l2:
        // p_k+1 = (x-1, y+1)
        add x17, x17, #1 // y = y+1
        sub x16, x16, #1 // x = x-1
        // Calculate P_k+1
        madd x15, x21, x17, x15  // P_k+1 = P_k + 2*((y_k) + 1)
        add x15, x15, #1        // P_k+1 = P_k + 2*((y_k) + 1) + 1
        msub x15, x21, x16, x15  // P_k+1 = P_k + 2*((y_k) + 1) - 2*((x_k) - 1) + 1
    inter_end: 
        // Repeat?
        cmp x17, x16    // Stop if x17 >= x16 (x >= y)
        B.LE loop_inter
/*
*
*/
    ldur lr, [sp]   // Restoring return pointer  
    ldur x15, [sp,#8] 
    ldur x16, [sp,#16]      
    ldur x17, [sp,#24]    
    ldur x21, [sp,#32]    
    add sp, sp, #48
br lr

//
shadow_octans: 
    sub sp, sp, #32
    stur lr, [sp]   // Saving return pointer
    stur x1, [sp,#8]
    stur x2, [sp,#16]
    stur x3, [sp,#24]
    /* 
    * Input : 
    *   - x16 : x coordinate of point
    *   - x17 : y coordinate of point
    *   - x10 : "brush" color
    */
    // (x,y) -> (-x,y)
        ldur x1, [sp,#8]
        ldur x2, [sp,#16]    
            // (-x,y)   
        sub x18, x1 ,x16    // x18 = -x 
            //(x,y)
        add x1, x1 ,x16    // x1 = x
        add x2, x2, x17    // x2 = y
    
        bl shadow_horizontal_line
        mov x3, x2         //

    // (x,y) -> (-x,-y)
        ldur x1, [sp,#8]
        ldur x2, [sp,#16]
            // (-x,-y)
        sub x18, x1 ,x16    // x18 = -x    
            // (x,-y)
        add x1, x1 ,x16    // x1 =  x
        sub x2, x2, x17    // x2 = -y
    
            cmp x3, x2      // skip if (x,y) = (-x,y)
            b.eq shad_skip_line1
        bl shadow_horizontal_line  
shad_skip_line1:

        cmp x16, x8
        b.eq shad_skip_paint2    // skip if line is filled already

    // (y,x) -> (-y,x)
        ldur x1, [sp,#8]
        ldur x2, [sp,#16]
            // (-y,x)
        sub x18, x1 ,x17    // x18 = -y
            // (y,x)
        add x1, x1 ,x17    // x1 = y
        add x2, x2, x16    // x2 = x
    
        cmp x3, x2          // skip if octans are the same
        b.eq shad_skip_paint2

        bl shadow_horizontal_line

    // (y,-x) -> (-y,-x)
        ldur x1, [sp,#8]
        ldur x2, [sp,#16]
            // (-y,-x)
        sub x18, x1 ,x17    // x18 = -y
            // (y,-x)
        add x1, x1 ,x17    // x1 = y
        sub x2, x2, x16    // x2 = -x

        bl shadow_horizontal_line
shad_skip_paint2:
    /*
    * Output:
    *    Paints 4 lines between positions:
    *       - (x,y) -> (-x,y), (x,-y) -> (-x,-y), (y,x) -> (-y,x), (y,-x) -> (-y,-x)
    */

    ldur x3, [sp,#24]
    ldur x2, [sp,#16]
    ldur x1, [sp,#8]
	ldur lr, [sp]   // Restoring return pointer  
    add sp, sp, #32
    br lr
// inter_end of shadow_octans

//
shadow_horizontal_line:
    sub sp, sp, #24
    stur lr, [sp]
    stur x13, [sp,#8]
    stur x0, [sp, #16]
    /*
    *   Input: 
    *       - (x1, x2)  = (x, y) of origin point
    *       - (x4, x5)  = (x, y) of center of moon
    *       - x18 = x coordinate of inter_end point
    */  
    // Calculate line length
    sub x13, x1, x18 // line_len = x0 - x1 (x0 >= x1) 
    bl coordinates  // brush at left side octan (x1, x2)
loop_shadow_line:
    bl paint_intersection  // paint
    sub x0, x0, #4  // move brush left
    sub x1, x1, #1  // move pixel left (x-1)

    cbz x13, shadow_line_end
    sub x13, x13, #1    
    cbnz x13, loop_shadow_line // paint till line_len = 0
shadow_line_end:
    /*
    *   Result:
    *       Horizontal line between the two points
    */
    ldur lr, [sp]       // restore values
    ldur x13, [sp,#8]
    ldur x0, [sp, #16]
    add sp, sp, #24 
    br lr           // Return
//

paint_intersection:
    sub sp, sp, #40
    stur lr, [sp]
    stur x15,[sp,#8]
    stur x14,[sp,#16]
    stur x13,[sp,#24]
    stur x11, [sp,#32]

    /*
    *   Input: 
    *       - (x1, x2)  = (x, y) pixel we want to paint
    *       - (x4, x5)  = (x, y) of center of moon
    *       - x11 = radius
    */  

    mul x15,x11,x11     //r^2

    sub x13, x1, x4     // (x1-x4)
    mul x13, x13, x13   // (x1-x4)^2

    sub x14, x2, x5     // (x2-x5)
    mul x14, x14, x14   // (x2-x5)^2
    
    add x13, x13, x14   // (x1-x4)^2 + (x2-x5)^2
    cmp x13, x15

    b.gt endPiC

    // paints the pixel (x1,x2)
    bl paint_pixel

    endPiC:

    ldur lr, [sp]
    ldur x15,[sp,#8]
    ldur x14,[sp,#16]
    ldur x13,[sp,#24]
    ldur x11, [sp,#32]
    add sp, sp, 40
    br lr

.endif
