# PS - Win64 GUI Framework in Assembly

This is a Windows GUI framework written completely in x64 MASM assembly. It creates a main application window, spawns threads, handles input events, and supports fullscreen toggling, all without using any external libraries or frameworks.

## How It Works

The project starts execution in `Main.asm`, which sets up a new thread and initializes the main application window. Once the window is ready, a button control is added dynamically. Input is captured through the Windows message loop, including support for mouse events and keypresses like F11 (which toggles fullscreen mode).

### Flow Overview

1. `Main.asm` starts by calling `NEWTHREAD`, passing in a callback `Loaded`.
2. The `Loaded` function waits for the main window handle to become valid.
3. Once the window exists, it creates a button inside that window using `NEW_CONTROL`.
4. `Window.asm` handles the window loop. It uses a manual message loop to:

   * Detect WM\_KEYDOWN and mouse messages
   * Toggle fullscreen on F11
   * Redraw and update the window
5. The window and control creation use raw WinAPI calls like `CreateWindowExA`, `ShowWindow`, and `UpdateWindow`.

## Files

* `Main.asm`: Entry point. Starts the thread and launches the window.
* `Window.asm`: Handles the message loop, fullscreen logic, and input.
* `Controls.asm`: Builds GUI controls (e.g. buttons).
* `Thread.asm`: Uses `CreateThread` to start the app's main thread.
* `WindowStruct.asm`: Contains shared structs like `WindowProperties`.

## Example

After compiling and running:

* A window titled "WORLD" appears (class name: STATIC)
* A button is rendered at position (200, 200), size (20x20)
* Pressing F11 toggles between windowed and fullscreen mode

