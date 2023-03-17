.include "data.s"
.include "libs/background.s"
.include "libs/circle.s"
.include "libs/DDA_line.s"
.include "libs/paint.s"
.include "libs/utils.s"
.include "libs/buffer.s"
.include "libs/cloud.s"

.include "graphs/moon.s"
.include "graphs/stars.s"
.include "graphs/clouds_g.s"
.include "graphs/eclipse.s"

.globl main
main:
	// X0 contiene la direccion base del framebuffer
 	mov x21, x0	// Save framebuffer base address to x21	
    adr x20, bufferSecundario
	//---------------- CODE HERE ------------------------------------

	/*
	* 	- Separamos las funciones lo mas posible para hacer el codigo mas entendible

	*	- Para dibujar las distintas formas:
	*		- Circulos : Hay dos variaciones, una vacia y la otra llena:
	*			- Vacia : Implementacion basada en el algoritmo del punto medio para el circulo.
	*			  		A partir del radio del circulo, el algoritmo calcula la posicion
	*			  		del siguiente pixel en base a la posicion del anterior, la nueva posicion
	*					es (x,y+1) o (x-1,y+1). Luego pinta 
	*					simetricamente los ocantes.
	*			- Llena : Basado en la implementacion anterior, solo que en vez de pintar 
	*			  		todos los octantes solo pintamos los 4 del lado derecho y dibujamos
	*			  		una linea hacia el extremo opuesto del circulo, de esta manera pintando
	*					su interior. 
	*		- Lineas : Algoritmo de Analizador diferencial digital. Toma dos pares de coordenadas
	*				y dibuja una linea que conecta ambos puntos. Hace esto calculando la pendiente 
	*				de la recta y eligiento el punto mas cercano a 
	*		- Fondo con degradé : A partir de un color y un numero natural z, pintamos la pantalla linea
	*				por linea, restando la variacion al color cada z lineas.
	
	*	- Double buffer : Para evitar el parpadeo de los graficos usamos la tecnica del double buffer.
	*		Al empezar el programa reservamos memoria suficiente para una "segunda pantalla" y pintamos a
	*		este buffer primero y luego pasamos la imagen completa al frame buffer del mailbox.

	*	- Transparencia : Usamos la tecnica de composicion de alfa, tomando el color que ya se encuentra 
	*		guardado en el buffer y aplicando las ecuaciones
	*			cmpA = dstA + (1-dstA)*scrA/100
	*			cmpC = ( dstC*dstA + (1-dstA)*scrA*srcC/100 )/cmpA
	*		para obtener el color final del pixel.

	*	- Coordenadas : Simplemente usamos la ecuacion 
	*			dir = orgDir + 4*[x+(y*640)] 
	*		para obtener la direccion de memoria del pixel (x,y).

	!	Puede que el double buffer no funcione, en ese caso se debe mover de data.s la linea que dice		
	*		bufferSecundario: .skip BYTES_FRAMEBUFFER
	!	y colocarla al principio o al final de app.s, antes de los include o despues de .endif

	*/

	mov x27, 0	// Frame counter
	mov x6, #6 // Size of stars
//-----------------------------------------
animation:
//- Sky ---
	movz x10, 0x6427, lsl 16	
	movk x10, 0x2737, lsl 00	// Set color to Very Dark Blue
	mov x5, #40					// Bands
	movz x11, 0x0003, lsl 16		
	movk x11, 0x0304, lsl 00	// Gradient change 
	bl gradient

//- Moon ---
	bl draw_moon

//- Stars ---
	movz x10, 0x64FF, lsl 16	
	movk x10, 0xFFFF, lsl 00	// Set color to White
	bl stars
//- Clouds----
	bl draw_clouds

//- Update Buffer ---
	bl updatefb	

	add x27, x27, #1

	and x15, x27, 1
	cbnz x15, star_skip
	sub x6, x6, #2
star_skip:
	
	cmp x27, SCREEN_WIDTH	// x27 varia entre 0 - 640

// reset frame
	b.le dont_reset_frame
	mov x27, #0
	
dont_reset_frame:
	cbnz x6, animation

	mov x6, #6 // Size of stars

	b animation

    //---------------------------------------------------------------
	// Infinite Loop 
InfLoop: 
	b InfLoop
