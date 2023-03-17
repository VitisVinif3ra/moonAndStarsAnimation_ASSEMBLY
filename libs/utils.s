.ifndef utils_s
.equ utils_s, 0

/*
* Conjunto de funciones variadas 
*/

//
delay:
	sub sp, sp, #16
    stur lr, [sp] 
    stur x3, [sp, #8]
    /* 
     * Input : 
     *   - None
    */
	movz x3, 0x8FF, lsl 16
	movk x3, 0xFFFF, lsl 00 // Guardamos en x3 el valor 0x8FFFFFF = 150.994.943
delay_loop:
	sub x3, x3, #1          // Restamos 1 a x3
	cbnz x3, delay_loop     // repetimos hasta que x3 == 0
                            // Esto hace que el procesador espere 150.994.943 ciclos
    /* 
     * Output : 
     *   - A fixed delay
    */
	ldur lr, [sp]
	ldur x3, [sp, #8]
    add sp, sp, #16
    br lr
//

//
coordinates:
    sub sp, sp, #32
    stur lr, [sp] // Save stack return pointer
    stur x9,[sp,#8]
    stur x1,[sp,#16]
    stur x2,[sp,#24]
    /* 
    * Input : 
    *   - x1  : x coordinate
    *   - x2 : y coordinate
	*	- x20 : starting memory position of "screen array"
    */
	mov x9, SCREEN_WIDTH
    madd x0, x2, x9, x1         // y coordinate * 640 + x // madd Xd, Xn, Xm, Xh = Xd = (Xn * Xm) + Xh
    lsl x0, x0, #2          	// *4   / 1000 = 1 => 0100 = 2 => 0010 = 4
	add x0, x20, x0             // + Direccion de inicio
    /* 
     * Output : 
     *   - x0 : "brush" set to point (x1,x2) in "screen array"
    */
	ldur lr, [sp]
    ldur x9,[sp,#8]
    ldur x1,[sp,#16]
    ldur x2,[sp,#24]
    add sp, sp, #32
    br lr
// end of coordinates

.endif

