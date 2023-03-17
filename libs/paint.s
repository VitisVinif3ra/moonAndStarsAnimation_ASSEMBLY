.ifndef paint_s
.equ paint_s, 0

.equ MEM, 88

.equ A_MASK, 0xFF000000
.equ R_MASK, 0x00FF0000
.equ G_MASK, 0x0000FF00
.equ B_MASK, 0x000000FF

.equ A_SHIFT, 24
.equ R_SHIFT, 16
.equ G_SHIFT, 8
.equ B_SHIFT, 0

paint_pixel:
    sub sp, sp, MEM
    stur lr, [sp]
    stur x1, [sp,8]
    stur x2, [sp,16]
    stur x3, [sp,24]
    stur x4, [sp,32]
    stur x5, [sp,40]
    stur x8, [sp,48]
    stur x9, [sp,56]
    stur x10, [sp,64]
    stur x11, [sp,72]
    stur x12, [sp,80]

   /*
   ? src = Source       : The color of the pixel already on screen
   ? dst = Destination  : The color of the pixel we want to print
   */
   
   // Skip pixel if off screen
      cmp x0, x20
      b.lt end_paint

   // Begin
      mov x12, #100
      ldur w9,[x0]                  // get src color
   // Composite transparency
      // Get alpha
         and x1, x10, A_MASK           // filter value
         sub x10, x10, x1              // A = 00
         lsr x1, x1, A_SHIFT        // dstA format to value
         and x2, x9, A_MASK            // filter value
         lsr x2, x2, A_SHIFT        // srcA format to value
      // Composite transparency
         sub x3, x1, x12            // x3 = dstA*100 - 100
         sub x3, xzr, x3            // x3 = -(dstA - 100) = (100 - dstA)
         mul x3, x3, x2             // x3 = (100 - dstA)*srcA
         sdiv x3, x3, x12           // x3 = (100 - dstA)*srcA / 100
         add x3, x3, x1             // x3 = dstA + (100 - dstA)*srcA / 100         
      // Add to final color
         lsl x3, x3, A_SHIFT
         add x10, x10, x3           // A = cmpA
         lsr x3, x3, A_SHIFT
      // Format cmpA for formulas
         // mul x3, x3, x12            // cmpA*100
   
   // Composite red
      // Get red
         and x4, x10, R_MASK              // filter value
         sub x10, x10, x4                 // R = 00
         lsr x4, x4, R_SHIFT           // dstC format to value
         and x5, x9, R_MASK               // filter value
         lsr x5, x5, R_SHIFT           // srcC format to value
      // Composite formula       
         sub x8, x1, x12         // x8 = dstA - 100
         sub x8, xzr, x8         // x8 = -(dstA - 100) = 100 - dstA
         mul x8, x8, x5          // x8 = (100 - dstA)*srcC
         mul x8, x8, x2          // x8 = (100 - dstA)*srcC*srcA
         sdiv x8, x8, x12
         mul x11, x4, x1         // x11 = dstC*dstA
         add x8, x8, x11         // x8 = dstC*dstA + (100 - dstA)*srcC*srcA
         sdiv x8, x8, x3         // [ dstC*dstA + (100 - dstA)*srcC*srcA ] / cmpA*100
      // Add to final color
         lsl x8, x8, R_SHIFT
         add x10, x10, x8        // R = cmpR
   // Composite green
      // Get green
         and x4, x10, G_MASK              // filter value
         sub x10, x10, x4                 // R = 00
         lsr x4, x4, G_SHIFT           // dstC format to value
         and x5, x9, G_MASK               // filter value
         lsr x5, x5, G_SHIFT           // srcC format to value
      // Composite formula       
         sub x8, x1, x12         // x8 = dstA - 100
         sub x8, xzr, x8         // x8 = -(dstA - 100) = 100 - dstA
         mul x8, x8, x5          // x8 = (100 - dstA)*srcC
         mul x8, x8, x2          // x8 = (100 - dstA)*srcC*srcA
         sdiv x8, x8, x12
         mul x11, x4, x1         // x11 = dstC*dstA
         add x8, x8, x11         // x8 = dstC*dstA + (100 - dstA)*srcC*srcA
         sdiv x8, x8, x3         // [ dstC*dstA + (100 - dstA)*srcC*srcA ] / cmpA*100
      // Add to final color
         lsl x8, x8, G_SHIFT
         add x10, x10, x8        // R = cmpR

   // Composite blue
      // Get green
         and x4, x10, B_MASK              // filter value
         sub x10, x10, x4                 // R = 00
         lsr x4, x4, B_SHIFT           // dstC format to value
         and x5, x9, B_MASK               // filter value
         lsr x5, x5, B_SHIFT           // srcC format to value
      // Composite formula       
         sub x8, x1, x12         // x8 = dstA - 100
         sub x8, xzr, x8         // x8 = -(dstA - 100) = 100 - dstA
         mul x8, x8, x5          // x8 = (100 - dstA)*srcC
         mul x8, x8, x2          // x8 = (100 - dstA)*srcC*srcA
         sdiv x8, x8, x12
         mul x11, x4, x1         // x11 = dstC*dstA
         add x8, x8, x11         // x8 = dstC*dstA + (100 - dstA)*srcC*srcA
         sdiv x8, x8, x3         // [ dstC*dstA + (100 - dstA)*srcC*srcA ] / cmpA*100
      // Add to final color
         lsl x8, x8, B_SHIFT
         add x10, x10, x8        // R = cmpR

   // Paint to screen
      stur w10, [x0]
    
   end_paint:
    ldur lr, [sp]
    ldur x1, [sp,8]
    ldur x2, [sp,16]
    ldur x3, [sp,24]
    ldur x4, [sp,32]
    ldur x5, [sp,40]
    ldur x8, [sp,48]
    ldur x9, [sp,56]
    ldur x10, [sp,64]
    ldur x11, [sp,72]
    ldur x12, [sp,80]
    add sp, sp, MEM
br lr

.endif
