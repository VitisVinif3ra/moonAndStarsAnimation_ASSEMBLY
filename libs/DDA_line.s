.ifndef line_s
.equ line_s, 0

/*
*   Implementation of DDA line algorithm
*/

.text 

line:
    sub sp, sp, #56
    stur lr, [sp]  
    stur x1, [sp, #8]
    stur x2, [sp,#16]
    stur x15,[sp,#24]
    /*
    *   Input: 
    *       - x1 = x_0
    *       - x2 = y_0
    *       - x16 = x_1
    *       - x17 = y_1
    */    
    // Transform everything to float
    scvtf s1, x1
    scvtf s2, x2
    scvtf s16, x16
    scvtf s17, x17
    // Calculate distance between points
    fsub s18, s16, s1 // dx = x_1-x_0
    fsub s19, s17, s2 // dy = y_1-y_0
    stur s18, [sp,#32]
    stur s19, [sp,#40]
    // abs of both
    fabs s18, s18
    fabs s19, s19
    // calculate steps
    fmax s15, s18, s19  // steps = max(abs(dx),abs(dy))
    ldur s18, [sp,#32]
    ldur s19, [sp,#40]
    // calculate x & y increase based on steps
    fdiv s18, s18, s15  // Xinc = dx / steps
    fdiv s19, s19, s15  // Yinc = dy / steps
    // paint the pixels
    fcvtas x15, s15
line_loop:
    
    fcvtas x1, s1   //Round(x)
    fcvtas x2, s2   //Round(y)
    bl coordinates
    bl paint_pixel  // paint pixel (x,y)

    fadd s1, s1, s19 // x += Xinc
    fadd s2, s2, s18 // y += Yinc

    sub x15, x15, #1    //repeat "steps" times
    cbnz x15, line_loop

    /*
    *   Output:
    *       Paints a line from (x1,x2) to (x16,x17)      
    */
	ldur lr, [sp]   // Restoring return pointer  
    ldur x1, [sp, #8]
    ldur x2, [sp,#16]
    ldur x15,[sp,#24]
    add sp, sp, #56
    br lr           // Return
//end of line_algorithm

.endif
