.ifndef buffer_s
.equ buffer_s, 0

updatefb:
	sub sp, sp, #8
	stur lr, [sp, #0]
	
    mov x0, x21
    mov x3, x20
//-----------------------------------------

	mov x2, SCREEN_HEIGH				// restart row pointer
fb_loop0:
	mov x1, SCREEN_WIDTH				// restart column pointer
fb_loop1:
    ldur w10, [x3]
	stur w10, [x0]
	add x0, x0, #4
    add x3, x3, #4

	sub x1, x1, #1

	cbnz x1, fb_loop1

	sub x2,x2,#1							// substract row from counter
	cbnz x2, fb_loop0						// jumps until last row

//-----------------------------------------
	ldur lr, [sp, #0]
	add sp, sp, #8
br lr
//

.endif
