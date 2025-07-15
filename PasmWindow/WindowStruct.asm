
.DATA
    FALSE EQU 0
    TRUE EQU 1

WindowProperties STRUCT
    IsInFullScreen      BYTE    0
    MainWindowHandle    QWORD   ?
    WindowClassName     QWORD   ?
    WindowName          QWORD   ?
    LPMSG               QWORD    ?
WindowProperties ENDS
.CODE
END