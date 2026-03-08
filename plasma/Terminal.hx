package plasma;

import plasma.types.Ansi;
import plasma.types.Style;

@:nullSafety(Strict)
final class Terminal {
	public static inline function execute(command:Style):Void {
		print(Renderer.style(command), false);
	}

	public static inline function print(command, ?ln:Bool = true):Void {
		#if js
		if (js.Syntax.typeof(untyped console) != "undefined" && (untyped console).log != null) {
			(untyped console).log(command);
		}
		#elseif lua
		untyped __define_feature__("use._hx_print", _hx_print(command));
		#elseif sys
		if (ln == true) {
			Sys.println(command);
		} else {
			Sys.print(command);
		}
		#else
		throw new haxe.exceptions.NotImplementedException()
		#end
	}

	/** 
	 * Hide the terminal cursor.
	 */
	public static inline function hideCursor():Void {
		execute(HideCursor);
	}

	/** 
	 * Reveal the terminal cursor.
	 */
	public static inline function showCursor():Void {
		execute(ShowCursor);
	}

	/** 
	 * Saves the current position of the cursor.
	 */
	public static inline function saveCursor():Void {
		execute(SaveCursor);
	}

	/** 
	 * Send the cursor to it's previously stored position.
	 */
	public static inline function restoreCursor():Void {
		execute(RestoreCursor);
	}

	/** 
	 * Purge all scrollable terminal content.
	 */
	public static inline function clearScroll():Void {
		execute(ClearScroll);
	}

	/** 
	 * Purge all content from the active terminal buffer.
	 */
	public static inline function clearScreen():Void {
		execute(ClearScreen);
	}

	/** 
	 * Purge all content on the current cursor line.
	 */
	public static inline function clearLine():Void {
		execute(ClearLine);
	}

	/** 
	 * Scroll the terminal up by one line.
	 */
	public static inline function scrollUp():Void {
		execute(ScrollUp);
	}

	/** 
	 * Scroll the terminal down by one line.
	 */
	public static inline function scrollDown():Void {
		execute(ScrollDown);
	}

	/**
	 * Enter the alternative buffer.
	 */
	public static inline function enterAltBuffer():Void {
		execute(EnterAltBuffer);
	}

	/**
	 * Leave the alternative buffer.
	 */
	public static inline function leaveAltBuffer():Void {
		execute(LeaveAltBuffer);
	}

	/** 
	 * Triggers an alert sound effect.
	 */
	public static inline function beep():Void {
		execute(Bell);
	}
}
