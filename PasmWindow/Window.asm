
EXTERN CreateWindowExA:PROC
EXTERN ShowWindow:PROC
EXTERN GetMessageA:PROC
EXTERN ExitProcess:PROC
EXTERN DispatchMessageA:PROC
EXTERN DestroyWindow:PROC
EXTERN TranslateMessage:PROC
EXTERN UpdateWindow:PROC
EXTERN SetForegroundWindow:PROC
EXTERN CloseWindow:PROC
EXTERN GetLastError:PROC
EXTERN SetFocus:PROC
EXTERN NEWTHREAD:PROC
EXTERN Beep:PROC
EXTERN MessageBoxW:PROC
PUBLIC NEW_WINDOW
WindowProperties STRUCT
    IsInFullScreen      BYTE    0
    MainWindowHandle    QWORD   ?
    WindowClassName     QWORD   ?
    WindowName          QWORD   ?
    LPMSG               QWORD    ?
	WindowHandleHandleSendBack Qword ?
	MainWindowMessageHandler QWORD ?

WindowProperties ENDS
.DATA
   dwStyle EQU 00C00000H
   LPMSG DB 44 DUP(?)
   WM_CLOSE EQU 0002H
   WM_KEYDOWN EQU 0100H
   VK_F11 EQU 7AH
   TRUE EQU 1
   FALSE EQU 0
   MOUSE_DOWN EQU 0080H
   MM BYTE 44 DUP(?)
   WINDOWNAME BYTE "MAINWINDOW",0
   WINDOWCLASS BYTE "STATIC",0
   WindowPropInfo WindowProperties <?>



.CODE
  
	NEW_WINDOW PROC 
	     MOV RSI,RCX
	     MOV RCX,SIZEOF WindowProperties
		 LEA RDI,[WindowPropInfo]
		 rep movsb
	     MOV R15,RSP 

		 sub rsp,5*8+8
		 MOV RCX,0H
		 MOV RDX,WindowPropInfo.WindowClassName
		 MOV R8,WindowPropInfo.WindowName
		 MOV R9,dwStyle
		 OR R9,00C00000H
		 OR R9,00080000H
		 OR R9,00040000H
		 OR R9,00020000H
		 OR R9,00010000H
		 OR R9,2000000H
		 PUSH 600
		 PUSH 800
		 PUSH 0
		 PUSH 0
		 PUSH 0 
         PUSH 0 
		 PUSH 0  
		 PUSH 0
		 CALL CreateWindowExA
		 CMP RAX,0
		 JE FAILED
		 JNE WINDOWCREATED

		;HANDLE_WINDOW:
		;    LEA RCX, WINDOWCREATED
		;	CALL NEWTHREAD
		;	MOV RSP,R15
		;	RET 
		WINDOWCREATED:
		    MOV RDX,[WindowPropInfo.WindowHandleHandleSendBack]
			MOV [RDX],rax
		    MOV RDX,[WindowPropInfo.MainWindowMessageHandler]
			LEA RBX ,GETMESSAGEPROC
			MOV [RDX],RBX
			MOV [WindowPropInfo.MainWindowHandle],rax
			MOV rcx,qword ptr [WindowPropInfo.MainWindowHandle]
			MOV rdx,5;show cmd
			CALL ShowWindow
			CALL GetLastError
			CMP RAX,0
			JNE FAILED 
            JMP GETMESSAGEPROC
       FAILED:
	    mov rax,-1
		ret
   
	NEW_WINDOW ENDP


	READ_INSTRUCTIONS PROC
	        LOCAL LPMSG_:QWORD
			MOV LPMSG_,RCX
			MOV RAX,LPMSG_
			CMP dword ptr [RAX+8],WM_KEYDOWN
			JE HANDLEINPUT 
		    MOV RAX,LPMSG_
			CMP dword ptr [RAX+8],MOUSE_DOWN
			JE MOUSEINPUT
			RET
	READ_INSTRUCTIONS ENDP
	GETMESSAGEPROC PROC
	         MOV RCX,qword ptr [WindowPropInfo.MainWindowHandle]
			 CALL SetFocus
			 LEA RCX,WindowPropInfo.LPMSG
	         MOV RDX,qword ptr [WindowPropInfo.MainWindowHandle]
	         MOV R8,0
	         MOV R9,0
	         CALL GetMessageA
	         LEA RCX,WindowPropInfo.LPMSG
	         CALL TranslateMessage
			 LEA RCX,WindowPropInfo.LPMSG
			 CALL READ_INSTRUCTIONS
			 JMP GETMESSAGEPROC
	
		
	GETMESSAGEPROC ENDP


	MOUSEINPUT PROC
	   LEA RCX,[WindowPropInfo.MainWindowHandle]
	   CALL SetForegroundWindow
	   JMP GETMESSAGEPROC

	MOUSEINPUT ENDP
	HANDLEINPUT PROC 
		LEA RAX,WindowPropInfo.LPMSG
		MOV dl, [RAX+16]
		CMP dl,VK_F11
		JE FULLSCREEN
		JMP GETMESSAGEPROC

	HANDLEINPUT ENDP
    
	UPDATEWINDOW_ MACRO 
	    LEA RCX,WindowPropInfo.MainWindowHandle
		CALL CloseWindow 

	ENDM

	FULLSCREEN PROC
       MOV RCX,qword ptr [WindowPropInfo.MainWindowHandle]
	   CMP WindowPropInfo.IsInFUllScreen,TRUE
	   JE SHOWMIN
	   JNE SHOWMAX

	   SHOWMAX:
	     MOV WindowPropInfo.IsInFUllScreen,TRUE
	     MOV RDX,3
		 JMP CHANGEWINDOW
	   SHOWMIN:
	    MOV WindowPropInfo.IsInFUllScreen,FALSE
	    MOV RDX,9
		JMP CHANGEWINDOW
	
	   CHANGEWINDOW:
	    CALL ShowWindow
		MOV RCX,qword ptr [WindowPropInfo.MainWindowHandle]
		CALL UpdateWindow
		
       JMP GETMESSAGEPROC
	FULLSCREEN ENDP

END