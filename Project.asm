;SUBMITTED BY: Mohammad Hissam Savul (20i-0780) & Omar Mughal (20i-0739)

include comb.lib
;MACRO FOR SETTING DELAY FOR SHAPES TO BE PRINTED
DELAY macro delay0
	local loop1,loop2
	mov cx,delay0
		loop1:
			mov dx,delay0
			loop2:
				sub dx,1
				cmp dx,0
				jne loop2
			loop loop1
endm

.model small
.stack 100h
.data
	
	;ALL VARIABLES
	num DW 0  
	temp dw ?  
	count db 0  
	countdi dw 0
	nameforfile db 'score.txt',0
	filehandle dw ?

	gamename db '***WELCOME TO CANDY CRUSH***','$'
	endlvl1 db '*!LEVEL# 1 COMPLETED!*','$'
	str1 db '----------------------------','$'
	askname db 'ENTER NAME & HIT ENTER: ','$'
	lvlwon db '*!YOU WON!*','$'
	lvllost db '*!YOU LOST!*','$'
	rulesHeading db "RULES AND OBJECTIVES: $"
	forContinue  db "Press spacebar to continue! $"
	forContinuetolvl2 db 'Press spacebar to continue to LVL2!','$'

	ruleLine1 db "1)Your goal in Candy Crush is to $"
	ruleLine2 db "clear as many rows and columns in $"
	ruleLine3 db "few moves as possible by lining $"
	ruleLine4 db "up three (or more) pieces of candy $"
	ruleLine5 db "in a row by swapping. $"

	ruleLine6 db "2)Reaching a certain score promotes $"
	ruleLine7 db "you to the next level. $"

	ruleLine8 db  "3)Combos can be made only horizontaly $"
	ruleLine9 db  "and vertically (not slanted). $"
	blankSpaces  db "                                $"
	lineString db "=============$"
	crushingString   db "| CRUSHING !|$"

	lineStringSingle db "***************$"
	explosionString  db "* EXPLOSIONS! *$"
	
	turnstr db '!Swap Turn!','$'
	noswapstr db '!No Swap!','$'
	
	dummy db '====================================','$'
	dummy2 db '********************************','$'


	x dw ?
	y dw ?
	limitx dw ?
	limity dw ?
	rowcount db 0
	allcandiesdone dw 0
	nextx dw ?
	nexty dw ?
	nextxlimit dw ?
	nextylimit dw ?
	randnumber dw ?
	scorestr db 'Score: ','$'
	userstr db 'Player 1 ','$'
	triesstr db 'Tries: ','$'
	tries dw 0
	
	allx dw 49 dup(?)
	ally dw 49 dup(?)
	allcandies dw 49 dup(?)
	allxlim dw 49 dup(?)
	allylim dw 49 dup(?)
	swapshapes dw 2 dup(?)
	swapcount dw 0
	countcands dw 0
	candy dw ?
	swapshape1 dw ?
	swapshape2 dw ?
	indexswapshape1 dw ?
	indexswapshape2 dw ?
	countsi dw 0
	comboonswap dw 0
	possiblecombsrow dw 0
	totalcols dw 0
	notincluded dw 10
	notincluded2 dw 12
	notincluded3 dw 8
	notincluded4 dw 6
	score dw 0
.code

main proc
	mov ax, @data
	mov ds,ax

	;VIDEO MODE SET
	mov ah,00h
	mov al,13	;pixels
	int 10h

	mov ah,0bh 
	mov bh,00
	mov bl,01h	;background color
	int 10h

	;for design (doted line)
	mov ah,02h				
    mov dh,11
    mov dl,6
    int 10h
    mov ah,09h
    mov dx,offset str1
    int 21h
	
	;for design (doted line)
	mov ah,02h				
    mov dh,13
    mov dl,6 
    int 10h
    mov ah,09h
    mov dx,offset str1
    int 21h
	
	;SETTING NAME OF GAME ON SCREEN
	delay 208  ;delay
	mov  ah, 00h      
	int 1AH

	mov ah,02h				
    mov dh,9
    mov dl,6	 
    int 10h
    mov ah,09h
    mov dx,offset gamename
    int 21h
	
	;SETTING NAME OF USER PROMPT
	delay 208  ;delay
	mov  ah, 00h      
	int 1AH

	mov ah,02h				
    mov dh,15
    mov dl,6	 
    int 10h

    mov ah,09h
    mov dx,offset askname
    int 21h

;multi input for name on screen
again:  
	mov ah, 01  
	int 21h  
	cmp al, 13  
	JE rulesShowing

	mov ah,0  
	sub al,48  
	mov temp,ax  
	mov ax,num  
	mov bx,10  
	mul bx  

	add ax,temp  
	mov num,ax  
	JMP again

	mov ah,02h				
    mov dh,11
    mov dl,11	 
    int 10h

    mov ah,09h
    mov dx,num
    int 21h	

rulesShowing:
	;-----------------------------------------------new screen (for the rules)---------------------
	;VIDEO MODE SET
	mov ah,00h
	mov al,13	;pixels
	int 10h

	mov ah,0bh 
	mov bh,00
	mov bl,01h	;background color
	int 10h
	
	;setting rules heading on top
	mov ah, 02h				
    mov dh, 1
    mov dl, 1	 
    int 10h
    mov ah, 09h
    mov dx, offset rulesHeading
    int 21h

	; 		RULES:
	; line 1
	delay 300  ;delay
	mov  ah, 00h      
	int 1AH

	mov ah, 02h				
    mov dh, 3
    mov dl, 1	 
    int 10h
    mov ah, 09h
    mov dx, offset ruleLine1
    int 21h

	; line 2
	delay 300  ;delay
	mov  ah, 00h      
	int 1AH

	mov ah, 02h				
    mov dh, 4
    mov dl, 3	 
    int 10h
    mov ah, 09h
    mov dx, offset ruleLine2
    int 21h

	; line 3
	delay 300  ;delay
	mov  ah, 00h      
	int 1AH

	mov ah, 02h				
    mov dh, 5
    mov dl, 3 
    int 10h
    mov ah, 09h
    mov dx, offset ruleLine3
    int 21h

	; line 4
	delay 300  ;delay
	mov  ah, 00h      
	int 1AH

	mov ah, 02h				
    mov dh, 6
    mov dl, 3 
    int 10h
    mov ah, 09h
    mov dx, offset ruleLine4
    int 21h

	; line 5
	delay 300  ;delay
	mov  ah, 00h      
	int 1AH 

	mov ah, 02h				
    mov dh, 7
    mov dl, 3	 
    int 10h
    mov ah, 09h
    mov dx, offset ruleLine5
    int 21h

	; line 6
	delay 300  ;delay
	mov  ah, 00h      
	int 1AH 
	
	mov ah, 02h				
    mov dh, 9
    mov dl, 1	 
    int 10h
    mov ah, 09h
    mov dx, offset ruleLine6
    int 21h

	; line 7
	delay 300  ;delay
	mov  ah, 00h      
	int 1AH 
	
	mov ah, 02h				
    mov dh, 10
    mov dl, 3	 
    int 10h
    mov ah, 09h
    mov dx, offset ruleLine7
    int 21h

	; line 8
	delay 300  ;delay
	mov  ah, 00h      
	int 1AH 
	
	mov ah, 02h				
    mov dh, 12
    mov dl, 1	 
    int 10h
    mov ah, 09h
    mov dx, offset ruleLine8
    int 21h

	; line 8
	delay 300  ;delay
	mov  ah, 00h      
	int 1AH 
	
	mov ah, 02h				
    mov dh, 13
    mov dl, 3	 
    int 10h
    mov ah, 09h
    mov dx, offset ruleLine9
    int 21h

	
blinkingContinue:
	;for the continue line
	delay 12  ;delay
	mov  ah, 00h      
	int 1AH 

	mov ah, 02h			
    mov dh, 23
    mov dl, 4 
    int 10h

	mov ah, 09h
    mov dx, offset blankSpaces
    int 21h

	mov ah, 02h			
    mov dh, 23
    mov dl, 4 
    int 10h

    mov ah, 09h
    mov dx, offset forContinue
    int 21h

	;asking for input to continue (any key pressed works)  
	mov ah, 01
	int 16h

	jz blinkingContinue

	mov ah, 0h
	int 16h

	cmp al, 32
	je moveon
	jmp blinkingContinue

	;-----------------------------------------------------------------------------------------
moveon:
	;-----------------------------------------------new screen
	call newscreenset


	;--------------------------------------------------------------GRID************
	call grid7x7
	
	;------------------------------------------------FOR TEXT ON CONSOLE
	
	call textwithgrid
	
	mov ah,02h				
    mov dh,17
    mov dl,28	 
    int 10h
	
	;----------------------------------------------------------------------7X7CANDIES********************	
	;COORDINATE FOR FIRST BLOCK
	mov nextx, 24
	mov nextxlimit, 39
	mov nexty, 24
	mov nextylimit, 39
	mov di,0
	
CANDIES49X49:	

	;RANDOMIZER FOR AVOIDING DISPLAY OF SAME SHAPES IN EVERY ROW
	call Randomizerforshapes
	
	;SETTING VALUES FOR SHAPE THAT IS TO BE CALLED
	call valuessetter
	
	;storing allx, ally and allcandies in arrays
	mov di,countdi
	mov ax,nextx
	mov allx[di], ax
	mov ax,nextxlimit
	mov allxlim[di],ax	
	
	mov ax,nexty
	mov ally[di], ax
	mov ax,nextylimit
	mov allylim[di],ax

	mov ax,randnumber
	mov allcandies[di], ax
	
	add di,2
	mov countdi,di
	
	call drawshapes
	
	;next row
	add nextx,23
	add nextxlimit,23
	
	;every candy printed increments total candies
	inc allcandiesdone
	
	;rowcount increment to keep track of rows for rows==7
	inc rowcount
	
	;if rowcount == 7, y added and x set back to first block
	cmp rowcount,7
	JE Setrowbacktofirst
	
HERE:
	;if allcandiesdone==49 then loop terminated
	cmp allcandiesdone,49
	JE griddone
	JMP CANDIES49X49
	
;setting row back to first block, and incrementing nexty for next row	
Setrowbacktofirst:
	mov nextx,24
	mov nextxlimit,39
	;y incremented after every row completed
	add nexty,23
	add nextylimit,23
	;rowcount set to 0 for next row tracking
	mov rowcount,0
	JMP HERE
;----------------------------------------------------------phase2
;-----------LEVEL1
griddone:

	.while(comboonswap != 1)
		combos
	.endw
	
	.while(tries < 15)
		
		;disp of turnstr
		mov ah,02h				
		mov dh,14	
		mov dl,26	 
		int 10h

		mov ah,09h
		mov dx,offset turnstr
		int 21h
			
		;swapping  turn
		mov swapcount,0
		call blockfoundaftermouseclick
		call blockhighlight
		mov ax, swapshapes[0]
		mov swapshape1,ax			;first clicked shape to swap
		mov indexswapshape1,di		;storing index

		delay 1000
		call blockfoundaftermouseclick
		call blockhighlight
		mov ax, swapshapes[1]
		mov swapshape2,ax			;second clicked swapshape
		mov indexswapshape2,di

		;swapping 2 clicked shapes
		mov di, indexswapshape1		;index of first clicked candy
		mov si, indexswapshape2		
		mov ax, allcandies[di]		
		mov bx, allcandies[si]
		mov allcandies[si], ax		
		
		mov cx, bx
		mov allcandies[di], cx
		
		;destroys all occurences of swapped candy if swapped with bomb
		.IF(allcandies[di] == 5)
			call bombswapped
			add comboonswap,3
		.ENDIF
		
		inc tries

		combos
		.IF(comboonswap == 1)
			
			;disp of noswapstr
			mov ah,02h				
			mov dh,20	
			mov dl,26	 
			int 10h

			mov ah,09h
			mov dx,offset noswapstr
			int 21h
			
			;swapping 2 clicked shapes back
			mov si, indexswapshape1		;index of first clicked candy
			mov di, indexswapshape2		
			mov ax, allcandies[di]		
			mov bx, allcandies[si]
			mov allcandies[si], ax		
			
			mov cx, bx
			mov allcandies[di], cx
					
			delay 1000
			call refreshscreen
		.ENDIF

		.while(comboonswap != 1)
			combos
		.endw
		
		
		;SCORE LIMIT
		.IF(score >= 80)
			JMP level1completed
		.ENDIF
		
	.endw
		
		
level1completed:
	delay 2000
	;VIDEO MODE SET
	mov ah,00h
	mov al,13	;pixels
	int 10h

	mov ah,0bh 
	mov bh,00
	mov bl,01h	;background color
	int 10h
	
	;SETTING NAME OF GAME ON SCREEN
	mov ah,02h				
    mov dh,10
    mov dl,10	 
    int 10h
    mov ah,09h
    mov dx,offset endlvl1
    int 21h
	
	mov ah,02h				
	mov dh,8
	mov dl,2	 
	int 10h
	mov ah,09h
	mov dx,offset dummy
	int 21h
	
	mov ah,02h				
	mov dh,12
	mov dl,4	 
	int 10h
	mov ah,09h
	mov dx,offset dummy2
	int 21h
	
	.IF(score >= 80)
		mov ah,02h				
		mov dh,14
		mov dl,14	 
		int 10h
		mov ah,09h
		mov dx,offset lvlwon
		int 21h
		
	.ELSE
		mov ah,02h				
		mov dh,14
		mov dl,14 
		int 10h
		mov ah,09h
		mov dx,offset lvllost
		int 21h
	.ENDIF
	
blinkingContinue2:
	;for the continue line
	delay 15  ;delay
	mov  ah, 00h      
	int 1AH 

	mov ah, 02h			
    mov dh, 23
    mov dl, 2 
    int 10h

	mov ah, 09h
    mov dx, offset blankSpaces
    int 21h

	mov ah, 02h			
    mov dh, 23
    mov dl, 2
    int 10h

    mov ah, 09h
    mov dx, offset forContinuetolvl2
    int 21h

	;asking for input to continue (any key pressed works)  
	mov ah, 01
	int 16h

	jz blinkingContinue2

	mov ah, 0h
	int 16h

	cmp al, 32
	je here3
	jmp blinkingContinue2
		
here3:
	;new file created and opened
	mov ah, 3ch
	mov dx, offset(nameforfile)
	mov cl,1
	int 21h
	mov filehandle,ax
	
	mov ah, 40h
	mov bx, filehandle
	mov cx, lengthof scorestr
	mov dx, offset(scorestr)
	int 21h
	
	mov ax, score
	
	mov ah,40h
	mov bx, filehandle
	mov cx, lengthof score
	mov dx, offset(score)
	int 21h
	
	
	
	
	
	;file closed
	mov ah,3eh
	mov dx, filehandle
	int 21h
		
exit:
	mov ah,4ch
	int 21h

MAIN ENdp

;--------------------------------------------PROCEDURES
restrictingcursor proc
	mov ax,7h
	mov cx,40	;x-axis
	mov dx,360
	int 33h

	mov ax,8h
	mov cx,20
	mov dx,180	;yaxis
	int 33h
	ret
restrictingcursor endp	

;setting video mode
newscreenset proc
	;VIDEO MODE SET
	mov ah,00h
	mov al,13	;pixels
	int 10h

	mov ah,0bh 
	mov bh,00
	mov bl,00h	;background color
	int 10h
	
	mov ax,2
	int 33h
	mov cx,500
	mov dx,50
	mov ax,4
	call restrictingcursor
	ret
newscreenset endp

;ftn for setting values
valuessetter proc
	
	;setting recieved values in x,y,limitx and limity
	mov ax,nextx
	mov x,ax
	mov ax,nextxlimit
	mov limitx,ax
	mov ax,nexty
	mov y,ax
	mov ax,nextylimit
	mov limity,ax
	ret
valuessetter endp

;FTN FOR DISPLAYING SQUARE
square proc
	mov si,x ;x-axis (initially)
	mov dx,y ;y-axis
	mov bx,limitx ;start from eg. 80-100 on x-axis
	mov al, 04h
	call Horizontallines
	mov si,x ;x-axis (initially)
	mov dx,limity ;y-axis
	mov bx,limitx ;start from eg. 80-100 on x-axis
	call Horizontallines
	mov si,y ;y-axis (initially)
	mov cx,x ;x-axis
	mov bx,limity ;start from eg. 50-70 on y-axis
	call Verticallines
	mov si,y ;y-axis (initially)
	mov cx,limitx ;x-axis
	inc limity
	mov bx,limity ;start from eg. 50-70 on y-axis
	call Verticallines
	ret
square endp

;FTN FOR RIGHT TRIANGLE
Righttriangle proc
	mov si,x ;x-axis (initially)
	mov dx,limity ;y-axis
	mov bx,limitx ;start from eg. 80-100 on x-axis
	mov al, 0AH
	call Horizontallines
	mov si,y ;y-axis (initially)
	mov cx,x ;x-axis
	mov bx,limity ;start from eg. 50-70 on y-axis
	inc limity
	call Verticallines
	mov si,x ;x-axis (initially)
	mov di,y ;y-axis
	mov bx,limity ;start from eg. 80-100 on x-axis
	call incSlantlines
	ret
Righttriangle endp

;FTN FOR L SHAPE
Lshape proc	
	mov si,x ;x-axis (initially)
	mov dx,limity ;y-axis
	mov bx,limitx ;start from eg. 80-100 on x-axis	;LONGEST LINE
	inc bx
	mov al, 07H	
	call Horizontallines
	mov si,x ;x-axis (initially)
	add si,5
	mov dx,limity ;y-axis
	sub dx,5
	mov bx,limitx ;start from eg. 80-100 on x-axis	;MEDIUM LINE
	inc bx
	call Horizontallines
	mov si,x ;x-axis (initially)
	mov dx,y ;y-axis
	mov bx,limitx ;start from eg. 80-100 on x-axis	;SHORTEST LINE
	sub bx,10
	call Horizontallines
	mov si,y ;y-axis (initially)
	mov cx,x ;x-axis
	mov bx,limity ;start from eg. 50-70 on y-axis	;LONGEST LINE
	call Verticallines
	mov si,y ;y-axis (initially)
	mov cx,x ;x-axis
	add cx,5
	mov bx,y ;start from eg. 50-70 on y-axis	;MEDIUM LINE
	add bx,11
	call Verticallines
	mov si,y ;y-axis (initially)
	add si,10
	mov cx,limitx ;x-axis
	mov bx,limity ;start from eg. 50-70 on y-axis	;SHORTEST LINE
	add bx,1
	call Verticallines
	ret
Lshape endp	

;FTN FOR LSHAPE BACKWARDS
LBackshape proc
	mov si,x ;x-axis (initially)
	mov dx,limity ;y-axis
	mov bx,limitx ;start from eg. 80-100 on x-axis	;LONGEST LINE
	mov al, 0DH
	call Horizontallines
	mov si,x ;x-axis (initially)
	mov dx,y ;y-axis
	add dx,10
	mov bx,x ;start from eg. 80-100 on x-axis	;medium line
	add bx,11
	call Horizontallines
	mov si,x ;x-axis (initially)
	add si,10
	mov dx,y ;y-axis
	mov bx,limitx ;start from eg. 80-100 on x-axis	;short line
	call Horizontallines
	mov si,y ;y-axis (initially)
	mov cx,limitx ;x-axis
	mov bx,limity ;start from eg. 50-70 on y-axis	;longest line
	inc bx
	call Verticallines
	mov si,y ;y-axis (initially)
	mov cx,x ;x-axis
	add cx,10
	mov bx,y ;start from eg. 50-70 on y-axis	;medium line
	add bx,10
	call Verticallines
	mov si,y ;y-axis (initially)
	add si,10
	mov cx,x ;x-axis
	mov bx,limity ;start from eg. 50-70 on y-axis	;shortest line
	call Verticallines
	ret
LBackshape endp	

;FTN FOR HOUR GLASS SHAPE
HourGlass proc
	mov si,x ;x-axis (initially)
	mov dx,y ;y-axis
	mov bx,limitx ;start from eg. 80-100 on x-axis	;LONGEST LINE
	inc bx
	mov al, 0EH
	call Horizontallines
	mov si,x ;x-axis (initially)
	mov di,limity ;y-axis
	mov bx,y ;start from eg. 80-100 on x-axis
	call decSlantlines
	mov si,x ;x-axis (initially)
	mov di,y ;y-axis
	mov bx,limity ;start from eg. 80-100 on x-axis
	call incSlantlines
	mov si,x ;x-axis (initially)
	mov dx,limity ;y-axis
	mov bx,limitx ;start from eg. 80-100 on x-axis
	inc bx
	call Horizontallines
	ret
HourGlass endp

;FTN FOR Bomb SHAPE
Bomb proc
	mov si,x ;x-axis (initially)
	mov dx,y ;y-axis
	mov bx,limitx ;start from eg. 80-100 on x-axis	;LONGEST LINE
	mov al, 09
	call Horizontallines
	mov si,x ;x-axis (initially)
	mov di,y ;y-axis
	mov bx,limity ;start from eg. 80-100 on x-axis
	inc bx
	call incSlantlines
	mov si,y ;y-axis (initially)
	mov cx,limitx ;x-axis
	mov bx,limity ;start from eg. 50-70 on y-axis
	call Verticallines
	mov si,x ;x-axis (initially)
	mov di,limity ;y-axis
	mov bx,y ;start from eg. 80-100 on x-axis
	call decSlantlines
	ret
Bomb endp	

;FTN FOR BARRICADE SHAPE
Barricade proc
	mov si,x ;x-axis (initially)
	mov dx,y ;y-axis
	mov bx,limitx ;start from eg. 80-100 on x-axis
	mov al, 0BH
	call Horizontallines
	mov si,x ;x-axis (initially)
	mov dx,y ;y-axis
	add dx,10
	mov bx,limitx ;start from eg. 80-100 on x-axis
	call Horizontallines
	mov si,y ;y-axis (initially)
	mov cx,x ;x-axis
	mov bx,limity ;start from eg. 50-70 on y-axis
	inc bx
	call Verticallines
	mov si,y ;y-axis (initially)
	mov cx,x ;x-axis
	add cx,5
	mov bx,limity ;start from eg. 50-70 on y-axis
	inc bx
	call Verticallines
	mov si,y ;y-axis (initially)
	mov cx,x ;x-axis
	add cx,10
	mov bx,limity ;start from eg. 50-70 on y-axis
	inc bx
	call Verticallines
	mov si,y ;y-axis (initially)
	mov cx,limitx ;x-axis
	mov bx,limity ;start from eg. 50-70 on y-axis
	inc bx
	call Verticallines
	ret
Barricade endp		

;ftn for block highlighting
blockhighlight proc
	mov ax, allx[di]
	sub ax,4
	mov nextx,ax
	mov bx, ally[di]
	sub bx,4
	mov nexty,bx
	mov cx, allxlim[di]
	add cx,4
	mov nextxlimit,cx
	mov dx, allylim[di]
	add dx,4
	mov nextylimit,dx
	call valuessetter
	mov ax, 02
    int 33h
	call square	
	mov ax, 01
    int 33h
	
	mov ax, allx[di]
	sub ax,3
	mov nextx,ax
	mov bx, ally[di]
	sub bx,3
	mov nexty,bx
	mov cx, allxlim[di]
	add cx,3
	mov nextxlimit,cx
	mov dx, allylim[di]
	add dx,3
	mov nextylimit,dx
	call valuessetter
	mov ax, 02
    int 33h
	call square	
	mov ax, 01
    int 33h
	ret
blockhighlight endp

blockfoundaftermouseclick proc
;to get coordinates of mouse click
	coordinatesonclick:
			mov ax,1
			int 33h
			mov ax, 03h
			int 33h
			test bl, 1		
		jz coordinatesonclick
		
		;storing y and x coordinates
		mov Y,dx
		shr cx,1
		mov X,cx
		
		mov di,0
	;TO FIND the shape coordinates on mouse click
	.WHILE (countcands < 49)	
		mov ax, allx[di]
		mov bx, ally[di]
		mov cx, allxlim[di]	
		mov dx, allylim[di]
		
		.IF(X >= ax && X <= cx && Y >= bx && Y <= dx)
			mov candy, di
			JMP blockfound
		.ENDIF	
		
		add di,2
		INC countcands
	.ENDW	
		
			
	blockfound:
		mov di,candy
		mov si,swapcount	
		mov ax, allcandies[di]
		mov swapshapes[si],ax
		inc swapcount
		mov di,candy
		mov countcands,0
		
	ret
blockfoundaftermouseclick endp

; proc for Horizontal lines
Horizontallines proc
	Hline1:
		mov ah,0ch
		mov cx, si
		int 10h
		inc si
		cmp si, bx ;for length
	JNE Hline1
	ret
Horizontallines endp

; proc for Verical lines
Verticallines proc
	VLine1:
		mov ah,0ch
		mov dx, si
		int 10h
		inc si
		cmp si, bx ;forlength
	JNE Vline1
	ret
Verticallines endp

; proc for slant lines
decSlantlines proc
	SLine1:
		mov ah,0ch
		mov cx, si
		mov dx, di
		int 10h
		inc si
		dec di
		cmp di, bx ;forlength
	JNE Sline1
	ret
decSlantlines endp

; proc for slant lines
incSlantlines proc
	SLine1:
		mov ah,0ch
		mov cx, si
		mov dx, di
		int 10h
		inc si
		inc di
		cmp di, bx ;forlength
	JNE Sline1
	ret
incSlantlines endp

;PROCEDURE FOR RANDOM NUMBER GENERATOR
Randomizerforshapes proc  
	REGO:
		delay 200  ;delay is 208
		mov  ah, 00h      
		int 1AH   
		
		mov  ax, dx
		xor  dx, dx
		mov  cx, 8  
		div  cx      
		mov dh, 0
		mov randnumber, dx
		cmp randnumber, 0
	JE REGO
	ret
Randomizerforshapes endp

;proc fro output of multi input
multiinout proc
output:  
	inc count 
	mov dx, 0  
	mov bx ,10  
	div bx  

	push dx   
	cmp ax,0  
	JE display  
	JMP output  

display:  
	dec count  
	pop dx  
	add dx,48  
	mov ah,02  
	int 21h  

	cmp count, 0  
	JNE display
	ret
   
multiinout endp	

grid7x7 proc
;for grid lines vertical
	mov si,20 ;y-axis (initially)
	mov cx,20 ;x-axis
	mov bx,182 ;start from eg. 50-70 on y-axis
	mov al, 0fh	;color of lines
	call Verticallines
	mov si,20 ;y-axis (initially)
	mov cx,43 ;x-axis
	call Verticallines
	mov si,20 ;y-axis (initially)
	mov cx,66 ;x-axis
	call Verticallines
	mov si,20 ;y-axis (initially)
	mov cx,89 ;x-axis
	call Verticallines
	mov si,20 ;y-axis (initially)
	mov cx,112 ;x-axis
	call Verticallines
	mov si,20 ;y-axis (initially)
	mov cx,135 ;x-axis
	call Verticallines
	mov si,20 ;y-axis (initially)
	mov cx,158 ;x-axis
	call Verticallines
	mov si,20 ;y-axis (initially)
	mov cx,181 ;x-axis
	call Verticallines
	
	;for grid lines horizontal
	mov si,20 ;x-axis (initially)
	mov dx,20 ;y-axis
	mov bx,181 ;start from eg. 80-100 on x-axis
	mov al, 0fh
	call Horizontallines
	mov si,20 ;x-axis (initially)
	mov dx,43 ;y-axis
	call Horizontallines
	mov si,20 ;x-axis (initially)
	mov dx,66 ;y-axis
	call Horizontallines
	mov si,20 ;x-axis (initially)
	mov dx,89 ;y-axis
	call Horizontallines
	mov si,20 ;x-axis (initially)
	mov dx,112 ;y-axis
	call Horizontallines
	mov si,20 ;x-axis (initially)
	mov dx,135 ;y-axis
	call Horizontallines
	mov si,20 ;x-axis (initially)
	mov dx,158 ;y-axis
	call Horizontallines
	mov si,20 ;x-axis (initially)
	mov dx,181 ;y-axis
	call Horizontallines
	ret
grid7x7 endp	

candiesdisp proc
	;COORDINATE FOR FIRST BLOCK
	mov nextx, 24
	mov nextxlimit, 39
	mov nexty, 24
	mov nextylimit, 39
	mov si,0
	mov rowcount,0
	mov allcandiesdone,0
	
	CANDIES49X49disp:	
	
	mov si,countsi
	mov ax, allcandies[si]
	mov randnumber, ax
	add countsi,2
	
	;SETTING VALUES FOR SHAPE THAT IS TO BE CALLED
	call valuessetter
	
	
	;CALLING SHAPES BASED ON RADUMNUMBER GENERATED BY RANDOMIZER
	.IF (randnumber == 1)
		;FOR SQUARE
		call square
	
	.ELSEIF (randnumber == 2)
		;FOR L SHAPE
		call Lshape
		
	.ELSEIF (randnumber == 3)
		;FOR Barricade shape
		call Barricade

	.ELSEIF (randnumber == 4)
		;FOR HourGlass SHAPE
		call HourGlass

	.ELSEIF (randnumber == 5)
		;FOR BOMB SHAPE
		call Bomb

	.ELSEIF (randnumber == 6)
		;FOR L (Backwards) SHAPE
		call LBackshape

	.ELSEIF (randnumber == 7)	
		;FOR RIGHT TRIANGLE SHAPE
		call Righttriangle

	.ENDIF	
	
	;next row
	add nextx,23
	add nextxlimit,23
	
	;every candy printed increments total candies
	inc allcandiesdone
	
	;rowcount increment to keep track of rows for rows==7
	inc rowcount
	
	;if rowcount == 7, y added and x set back to first block
	cmp rowcount,7
	JE Setrowbacktofirstagain
	
HEREagain:
	;if allcandiesdone==49 then loop terminated
	cmp allcandiesdone,49
	JE goingout
	JMP CANDIES49X49disp
	
;setting row back to first block, and incrementing nexty for next row	
Setrowbacktofirstagain:
	mov nextx,24
	mov nextxlimit,39
	;y incremented after every row completed
	add nexty,23
	add nextylimit,23
	;rowcount set to 0 for next row tracking
	mov rowcount,0
	JMP HEREagain


goingout:
	ret
candiesdisp endp

drawshapes proc
	;CALLING SHAPES BASED ON RADUMNUMBER GENERATED BY RANDOMIZER
	.IF (randnumber == 1)
		;FOR SQUARE
		call square
	
	.ELSEIF (randnumber == 2)
		;FOR L SHAPE
		call Lshape
		
	.ELSEIF (randnumber == 3)
		;FOR Barricade shape
		call Barricade

	.ELSEIF (randnumber == 4)
		;FOR HourGlass SHAPE
		call HourGlass

	.ELSEIF (randnumber == 5)
		;FOR BOMB SHAPE
		call Bomb

	.ELSEIF (randnumber == 6)
		;FOR L (Backwards) SHAPE
		call LBackshape

	.ELSEIF (randnumber == 7)	
		;FOR RIGHT TRIANGLE SHAPE
		call Righttriangle

	.ENDIF	
	ret
drawshapes endp

textwithgrid proc
	;DISPLAYING user
	mov ah,02h				
    mov dh,3
    mov dl,26	 
    int 10h

    mov ah,09h
    mov dx,offset userstr
    int 21h

	
	;DISPLAYING score 
	mov ah,02h				
    mov dh,5
    mov dl,26	 
    int 10h

    mov ah,09h
    mov dx,offset scorestr
    int 21h
	
	;updated score
	mov ah,02h				
    mov dh,5
    mov dl,33	 
    int 10h

    mov ax, score
	call multiinout
	
	;DISPLAYING tries
	mov ah,02h				
    mov dh,7
    mov dl,26	 
    int 10h

    mov ah,09h
    mov dx,offset triesstr
    int 21h
	
	;updated score
	mov ah,02h				
    mov dh,7
    mov dl,33	 
    int 10h

    mov ax, tries
	call multiinout
	ret
textwithgrid endp	

refreshscreen proc
	call newscreenset
	call textwithgrid
	call grid7x7
	mov countsi,0
	call candiesdisp
	ret
refreshscreen endp

crushstr proc
	mov ah,02h				
    mov dh,18	
    mov dl,24	 
    int 10h

    mov ah,09h
    mov dx,offset lineString
    int 21h
	
	mov ah,02h				
    mov dh,20	
    mov dl,24 
    int 10h

    mov ah,09h
    mov dx,offset crushingString
    int 21h
	
	mov ah,02h				
    mov dh,22	
    mov dl,24	 
    int 10h

    mov ah,09h
    mov dx,offset lineString
    int 21h
	ret
crushstr endp

explosiondisp proc
	mov ah,02h				
    mov dh,18	
    mov dl,24	 
    int 10h

    mov ah,09h
    mov dx,offset lineStringSingle
    int 21h
	
	mov ah,02h				
    mov dh,20	
    mov dl,24	 
    int 10h

    mov ah,09h
    mov dx,offset explosionString
    int 21h
	
	mov ah,02h				
    mov dh,22	
    mov dl,24	 
    int 10h

    mov ah,09h
    mov dx,offset lineStringSingle
    int 21h
	ret
explosiondisp endp	

bombswapped proc
	;new random candies
	mov comboonswap,1
	mov allcandiesdone,0
	mov di,0
	mov ax, allcandies[si] ; first
	.while (allcandiesdone <49)
		mov bx, allcandies[di]	;all in turns
		.IF(bx == ax)
			mov allcandies[di],0
			add score,1
			inc comboonswap
		.ENDIF
		inc allcandiesdone
		add di,2
	.endw
	
	;removing bomb as well
	mov bx,indexswapshape1
	mov allcandies[bx],0
	
	delay 1000
	call refreshscreen
			
	call explosiondisp		
	;new random candies
	mov allcandiesdone,0
	mov si,0
	.while (allcandiesdone <49)
		.IF(allcandies[si] == 0)
			call Randomizerforshapes
			mov bx, randnumber
			mov allcandies[si],bx
		.ENDIF
		inc allcandiesdone
		add si,2
	.endw
	delay 1000
	call refreshscreen
	ret
bombswapped endp	

end main
