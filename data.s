.ifndef data_s
.equ data_s, 0

/*
* Constantes
*/

.data

bufferSecundario: .skip BYTES_FRAMEBUFFER

dir_frameBuffer: .dword 0

.equ SCREEN_PIXELS, SCREEN_WIDTH * SCREEN_HEIGH
.equ BYTES_PER_PIXEL, 4
.equ BITS_PER_PIXEL, 8 * BYTES_PER_PIXEL
.equ BYTES_FRAMEBUFFER, SCREEN_PIXELS * BYTES_PER_PIXEL

.equ SCREEN_WIDTH, 640
.equ SCREEN_HEIGH, 480
.equ BITS_PER_PIXEL, 32
.equ LAST_PIXEL_ROW, 2560

.endif
