.ifndef circle_s
.equ circle_s, 0

.text 

/*
* Implementation of Bresenham's circle algorithm
*/

//
empty_circle:
    sub sp, sp, #48
    stur lr, [sp]   // Saving return pointer
    stur x15, [sp,#8]
    stur x16, [sp,#16]
    stur x17, [sp,#24]
    stur x21, [sp,#32]
    /* 
    * Input : 
    *   - x1 : x coordinate of center of circle    
    *   - x2 : y coordinate of center of circle
    *   - x11 : radius of circle
    *   - x10 : "brush" color
    
    *   Registers:
    *       X15 : P_k
    *       X16 : x coordinate of circle
    *       X17 : y coordinate of circle
    *       x21 : contains 2, just for multiplications
    */
    // Initialize x21 = 2
    mov x21, #2
    // Initialize x16 = x11 and x17 = 0
    add x16, xzr, x11   // x = r
    add x17, xzr, xzr   // y = 0
    // Initialize P_1 to 1-r
    sub x15, xzr, x11   // x15 = -x11 = -r
    add x15, X15, #1    // x15 = -x11 + 1 = 1-r || P_1 = 1-r
loop_p:
    // Paint pixels
    bl paint_octans
    // Decision tree
    cmp x15, xzr
    B.LE l1    // if P_k <= 0 then (x,y) = (x,y+1)
    B.GT l2    // if P_k > 0 then (x,y) = (x-1,y+1)
l1:
    add x17, x17, #1 // y = y+1
    // Calculate P_k+1
    madd x15, x21, x17, x15  // P_k+1 = P_k + 2*((y_k) + 1)
    add x15, x15, #1        // P_k+1 = P_k + 2*((y_k) + 1) + 1
    B end
l2:
    // p_k+1 = (x-1, y+1)
    add x17, x17, #1 // y = y+1
    sub x16, x16, #1 // x = x-1
    // Calculate P_k+1
    madd x15, x21, x17, x15  // P_k+1 = P_k + 2*((y_k) + 1)
    add x15, x15, #1        // P_k+1 = P_k + 2*((y_k) + 1) + 1
    msub x15, x21, x16, x15  // P_k+1 = P_k + 2*((y_k) + 1) - 2*((x_k) - 1) + 1
end: 
    // Repeat?
    cmp x17, x16    // Stop if x17 >= x16 (x >= y)
    B.LE loop_p
    /* 
     * Output : 
     *  Paints a circle to screen with center (x1,x2) and radius x11
    */

	ldur lr, [sp]   // Restoring return pointer  
    ldur x15, [sp,#8] 
    ldur x16, [sp,#16]      
    ldur x17, [sp,#24]    
    ldur x21, [sp,#32]    
    add sp, sp, #48 // Free memory
    br lr           // Returning
//end of circle

//
paint_octans:
    sub sp, sp, #24
    stur x2, [sp,#16]
    stur x1, [sp,#8]
    stur lr, [sp]   // Saving return pointer
    /* 
    * Input : 
    *   - x16 : x coordinate of point
    *   - x17 : y coordinate of point
    *   - x10 : "brush" color
    */
    //(x,y)
    ldur x1, [sp,#8]
    add x1, x1 ,x16    // x1 = x
    ldur x2, [sp,#16]
    add x2, x2, x17    // x2 = y
    bl coordinates
    stur w10,[x0]	
    // (-x,y)
    ldur x1, [sp,#8]    
    sub x1, x1 ,x16    // x1 = -x 
    ldur x2, [sp,#16]
    add x2, x2, x17    // x2 =  y
    bl coordinates
    stur w10,[x0]	
    // (-x,-y)
    ldur x1, [sp,#8]
    sub x1, x1 ,x16    // x1 = -x
    ldur x2, [sp,#16]
    sub x2, x2, x17    // x2 = -y
    bl coordinates
    stur w10,[x0]	
    // (x,-y)
    ldur x1, [sp,#8]
    add x1, x1 ,x16    // x1 =  x
    ldur x2, [sp,#16]
    sub x2, x2, x17    // x2 = -y
    bl coordinates
    stur w10,[x0]	   

    // (y,x)
    ldur x1, [sp,#8]
    add x1, x1 ,x17    // x1 = y
    ldur x2, [sp,#16]
    add x2, x2, x16    // x2 = x
    bl coordinates
    stur w10,[x0]	
    // (-y,x)
    ldur x1, [sp,#8]
    sub x1, x1 ,x17    // x1 = y
    ldur x2, [sp,#16]
    add x2, x2, x16    // x2 = x
    bl coordinates
    stur w10,[x0]
    // (-y,-x)
    ldur x1, [sp,#8]
    sub x1, x1 ,x17    // x1 = y
    ldur x2, [sp,#16]
    sub x2, x2, x16    // x2 = x
    bl coordinates
    stur w10,[x0]
    // (y,-x)
    ldur x1, [sp,#8]
    add x1, x1 ,x17    // x1 = y
    ldur x2, [sp,#16]
    sub x2, x2, x16    // x2 = x
    bl coordinates
    stur w10,[x0]
    /*
    * Output:
    *    Paints 8 pixels at positions:
    *       - (y,x),(x,y),(x,-y),(y,-x),(-y,-x),(-x,-y),(-x,y),(-y,x)
    */

    ldur x2, [sp,#16]
    ldur x1, [sp,#8]
	ldur lr, [sp]   // Restoring return pointer  
    add sp, sp, #24
    br lr
// end of paint_octans

//-----------------------------------------------------------------------------

//
filled_circle:
    sub sp, sp, #48
    stur lr, [sp]   // Saving return pointer
    stur x15, [sp,#8]  
    stur x16, [sp,#16]      
    stur x17, [sp,#24]   
    stur x21, [sp,#32]
    stur x8, [sp,#40]     
    /* 
    * Input : 
    *   - x1 : x coordinate of center of circle    
    *   - x2 : y coordinate of center of circle
    *   - x11 : radius of circle
    *   - x10 : "brush" color
    */
    // Initialize x21 = 2
    mov x21, #2
    // Initialize x16 = x11 and x17 = 0
    add x16, xzr, x11   // x = r
    add x17, xzr, xzr   // y = 0
    // Initialize P_1 to 1-r
    sub x15, xzr, x11   // x15 = -x11 = -r
    add x15, X15, #1    // x15 = -x11 + 1 = 1-r || P_1 = 1-r
filled_loop_p:
    // Paint pixels
    bl fill_octans
skip_paint1:
    // Decision tree
    mov x8, x16
    cmp x15, xzr
    B.LE filled_l1    // if P_k <= 0 then (x,y) = (x,y+1)
    B.GT filled_l2    // if P_k > 0 then (x,y) = (x-1,y+1)
filled_l1:
    add x17, x17, #1 // y = y+1
    // Calculate P_k+1
    madd x15, x21, x17, x15  // P_k+1 = P_k + 2*((y_k) + 1)
    add x15, x15, #1        // P_k+1 = P_k + 2*((y_k) + 1) + 1
    B filled_end
filled_l2:
    // p_k+1 = (x-1, y+1)
    add x17, x17, #1 // y = y+1
    sub x16, x16, #1 // x = x-1
    // Calculate P_k+1
    madd x15, x21, x17, x15  // P_k+1 = P_k + 2*((y_k) + 1)
    add x15, x15, #1        // P_k+1 = P_k + 2*((y_k) + 1) + 1
    msub x15, x21, x16, x15  // P_k+1 = P_k + 2*((y_k) + 1) - 2*((x_k) - 1) + 1
filled_end: 
    // Repeat?
    cmp x17, x16    // Stop if x17 >= x16 (x >= y)
    B.LE filled_loop_p
    /* 
     * Output : 
     *  Paints a circle to screen with center (x1,x2) and radius x11
    */

	ldur lr, [sp]   // Restoring return pointer  
    ldur x15, [sp,#8] 
    ldur x16, [sp,#16]      
    ldur x17, [sp,#24]    
    ldur x21, [sp,#32]    
    ldur x8, [sp,#40] 
    add sp, sp, #48
br lr           // Returning
//end of circle
//

//
fill_octans: 
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
    
        bl horizontal_line
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
            b.eq skip_line1
        bl horizontal_line  
skip_line1:

        cmp x16, x8
        b.eq skip_paint2    // skip if line is filled already

    // (y,x) -> (-y,x)
        ldur x1, [sp,#8]
        ldur x2, [sp,#16]
            // (-y,x)
        sub x18, x1 ,x17    // x18 = -y
            // (y,x)
        add x1, x1 ,x17    // x1 = y
        add x2, x2, x16    // x2 = x
    
        cmp x3, x2          // skip if octans are the same
        b.eq skip_paint2

        bl horizontal_line

    // (y,-x) -> (-y,-x)
        ldur x1, [sp,#8]
        ldur x2, [sp,#16]
            // (-y,-x)
        sub x18, x1 ,x17    // x18 = -y
            // (y,-x)
        add x1, x1 ,x17    // x1 = y
        sub x2, x2, x16    // x2 = -x

        bl horizontal_line
skip_paint2:
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
// end of filled_octans

//
horizontal_line:
    sub sp, sp, #24
    stur lr, [sp]
    stur x11, [sp,#8]
    stur x0, [sp, #16]
    /*
    *   Input: 
    *       - (x1, x2)  = (x, y) of origin point
    *       - x18 = x coordinate of end point
    */  
    // Calculate line length
    sub x11, x1, x18 // line_len = x0 - x1 (x0 >= x1) 
    bl coordinates  // brush at left side octan (x1, x2)
loop_line:
    bl paint_pixel  // paint
    sub x0, x0, #4  // move brush left
    cbz x11, line_end
    sub x11, x11, #1    
    cbnz x11, loop_line // paint till line_len = 0
line_end:
    /*
    *   Result:
    *       Horizontal line between the two points
    */

    ldur lr, [sp]       // restore values
    ldur x11, [sp,#8]
    ldur x0, [sp, #16]
    add sp, sp, #24 
    br lr           // Return
//

.endif
