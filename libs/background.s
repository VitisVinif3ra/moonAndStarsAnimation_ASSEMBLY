.ifndef background_s
.equ background_s,	0

/*
*	"Libreria" con funciones para pintar fondos
*/

.globl ckeckered
background:
	sub sp, sp, #24
	stur lr, [sp, #0]
	stur x1, [sp, #8]
	stur x2, [sp, #16]
	mov x0, x20
//-----------------------------------------

	mov x2, SCREEN_HEIGH				// restart row pointer
loop0:
	mov x1, SCREEN_WIDTH				// restart column pointer
loop1:
	stur w10,[x0]
	add x0, x0, #4

	sub x1, x1, #1

	cbnz x1, loop1

	sub x2,x2,#1							// substract row from counter
	cbnz x2, loop0						// jumps until last row

//-----------------------------------------
	ldur lr, [sp, #0]
	ldur x1, [sp, #8]
	ldur x2, [sp, #16]
	add sp, sp, #24
br lr
//

//----
gradient:
	sub sp, sp, #32
	stur lr, [sp, #0]
	stur x1, [sp, #8]
	stur x2, [sp, #16]
	stur x5, [sp, #24]
	/*
	*	x5 : Gradient size
	*	x11 : Gradient ammount	
	*/
	mov x0, x20
//-----------------------------------------
	mov x2, SCREEN_HEIGH				// restart row pointer
grad_height_loop:
	mov x1, SCREEN_WIDTH				// restart column pointer
grad_width_loop:
	bl paint_pixel
	add x0, x0, #4

	sub x1, x1, #1
	cbnz x1, grad_width_loop

	sub x5, x5, #1
	cbnz x5, keep_color
	cmp x10, x11
	B.LT keep_color
	sub x10, x10, x11
	ldur x5, [sp, #24]
keep_color:
	sub x2,x2,#1							// substract row from counter
	cbnz x2, grad_height_loop						// jumps until last row

//-----------------------------------------
	
	/*
	*
	*/
	ldur x5, [sp, #24]
	ldur x2, [sp, #16]
	ldur x1, [sp, #8]
	ldur lr, [sp]
	add sp, sp, #32
br lr	
// End of gradient

// NOT WORKING
mist:
    sub sp, sp, 32
    stur lr,[sp]
	stur x1, [sp, #8]
	stur x2, [sp, #16]
	ldur x10,[sp,#24]
	mov x0, x20
//-----------------------------------------

	mov x2, SCREEN_HEIGH				// restart row pointer
mist_height:
	mov x1, SCREEN_WIDTH				// restart column pointer
mist_width:
	//ldur w10, [x0]
	add x10, x10, x9
	bl paint_pixel
	add x0, x0, #4

	sub x1, x1, #1

	cbnz x1, loop1

	sub x2,x2,#1							// substract row from counter
	cbnz x2, loop0						// jumps until last row

//-----------------------------------------
    ldur lr,[sp]
	ldur x1,[sp,#8]
	ldur x2,[sp,#16]
	ldur x10,[sp,#24]
    add sp, sp, 32
br lr
// End of mist
.endif
