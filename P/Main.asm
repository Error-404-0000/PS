EXTERN NEW_WINDOW:PROC
EXTERN NEWTHREAD:PROC
EXTERN GetCurrentThread:PROC
EXTERN SuspendThread:PROC
EXTERN NEW_CONTROL:PROC
ControlProperties STRUCT
    MainWindowHandle    QWORD   ?
    WindowClassName     QWORD   ?
    WindowName          QWORD   ?
    X                   QWORD   ?
    Y                   QWORD   ?
    nWidth              QWORD   ?
    nHeigth             QWORD   ?
    LPMSG               QWORD   ?
    MainWindowMessageHandler QWORD ?
    ParentHandle QWORD ?
ControlProperties ENDS
WindowProperties STRUCT
    IsInFullScreen      BYTE    0
    MainWindowHandle    QWORD   ?
    WindowClassName     QWORD   ?
    WindowName          QWORD   ?
    LPMSG               QWORD    ?
    WindowHandleHandleSendBack QWORD ?
    MainWindowMessageHandler QWORD ?

WindowProperties ENDS


.DATA
    BUTTON_HANDLE QWORD 0
    NAMEE BYTE "STATIC",0
    BUTTON BYTE "BUTTON",0
    MEME BYTE "WORLD",0
    LPMSG BYTE 44 DUP(?)
    LPMSG3 BYTE 44 DUP(?)
    MainWindowHandle QWORD 0
    MainWindowMessageHandler QWORD ?
    LP WindowProperties <0,0,OFFSET NAMEE,OFFSET MEME,OFFSET LPMSG,OFFSET MainWindowHandle,OFFSET MainWindowMessageHandler>
    CLP ControlProperties <OFFSET BUTTON_HANDLE,OFFSET BUTTON,OFFSET BUTTON,200,200,20,20,?,OFFSET MainWindowHandle>
.CODE
   Main PROC

        LEA R9,LP
        LEA RCX,Loaded
		CALL NEWTHREAD
        LEA RCX,LP
		CALL NEW_WINDOW

		RET
		
   Main ENDP
   Loaded PROC
    MOV RDX,[LP.WindowHandleHandleSendBack]
    MOV RDX,[RDX]
    cmp RDX,0
    JE Loaded
    MOV [CLP.ParentHandle],RDX
    LEA RCX,CLP
    CALL NEW_CONTROL
    RET
   Loaded ENDP
END