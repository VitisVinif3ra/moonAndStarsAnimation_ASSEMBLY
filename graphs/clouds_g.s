.ifndef clouds_g_s
.equ clouds_g_s, 0 

.equ cloud_mem, 16

draw_clouds:
    sub sp, sp, cloud_mem
    stur lr, [sp]
	stur x27, [sp,#8]

	movz x10, 0x60F0, lsl 16	
	movk x10, 0xF0F0, lsl 00
	mov x1, 80
	mov x2, 50
	lsl x27, x27, 1
	add x1, x1, x27
	mov x11, 70
	bl draw_cloud1
	ldur x27, [sp,#8]

	movz x10, 0x60F8, lsl 16	
	movk x10, 0xF8F8, lsl 00

	mov x1, 150
	mov x2, 100
	add x1, x1, x27
	mov x11, 70
	bl draw_cloud1

	movz x10, 0x60E0, lsl 16	
	movk x10, 0xE0E0, lsl 00

	mov x1, 0
	mov x2, 100
	lsl x27, x27, 2
	add x1, x1, x27
	mov x11, 70
	bl draw_cloud1
	ldur x27, [sp,#8]

	movz x10, 0x60E4, lsl 16	
	movk x10, 0xE4E4, lsl 00

	mov x1, 400
	mov x2, 250
	add x1, x1, x27
	mov x11, 70
	bl draw_cloud1

	movz x10, 0x60E9, lsl 16	
	movk x10, 0xE9E9, lsl 00

	mov x1, 460
	mov x2, 200
	lsl x27, x27, 1
	add x1, x1, x27
	mov x11, 70
	bl draw_cloud1
	ldur x27, [sp,#8]

	movz x10, 0x60EA, lsl 16	
	movk x10, 0xEAEA, lsl 00

	mov x1, 470
	mov x2, 80
	add x1, x1, x27
	mov x11, 70
	bl draw_cloud1

    ldur lr, [sp]
	ldur x27, [sp,#8]
    add sp, sp, cloud_mem
br lr

.endif
