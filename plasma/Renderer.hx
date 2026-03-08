package plasma;

import plasma.types.Ansi;
import plasma.types.Style;
import plasma.internal.Support.support;

@:nullSafety(Strict)
final class Renderer {
	/**
	 * Applies a list of styles to the specified text.
	 * 
	 * @param text The string to be styled.
	 * @param styles An array of styles to apply.
	 * @param forceSupport (Optional) Whether to override the default support level.
	 */
	@:pure public static function render(str:String, styles:Array<Style>, ?forcedSupportLevel:Null<Int>):Ansi {
		final strBuf:StringBuf = new StringBuf();
		for (i in styles) {
			final style:String = style(i, forcedSupportLevel);
			strBuf.add(style);
		}

		strBuf.add(str);
		strBuf.add(style(Reset));
		return strBuf.toString();
	}

	/**
	 * Returns the ANSI sequence of the given style.
	 * @param style The style whose sequence you are trying to acquire.
	 * @param supportLevel (Optional) Whether you want to bypass the predetermined support level, or not.
	 */
	@:pure @:noUsing 
	public static inline function style(style:Style, ?supportLevel:Null<Int>):Ansi {
		if(supportLevel != null && supportLevel == -1) supportLevel = null;
		final support:Int = supportLevel ?? cast support;
		
		return switch style {
			case Reset if (support > 0): "\x1b[0m";
			case Bold if (support > 0): "\x1b[1m";
			case Dim if (support > 0): "\x1b[2m";
			case Italic if (support > 0): "\x1b[3m";
			case Underline if (support > 0): "\x1b[4m";
			case Inverse if (support > 0): "\x1b[7m";
			case Hidden if (support > 0): "\x1b[8m";
			case Strikethrough if (support > 0): "\x1b[9m";
			case Visible if (support > 0): "\x1b[28m";
			case Overline if (support > 0): "\x1b[53m";
			case DoubleUnderline if (support > 0): "\x1b[21m";
			case SlowBlink if (support > 0): "\x1b[5m";
			case RapidBlink if (support > 0): "\x1b[6m";

			case FgBasic(i) if (support >= 1): "\x1b[" + (30 + i) + "m";
			case FgBright(i) if (support >= 1): "\x1b[" + (90 + i) + "m";
			case FgAnsi256(i) if (support >= 2): "\x1b[38;5;" + i + "m";
			case FgRgb(r, g, b) if (support >= 3): "\x1b[38;2;" + r + ";" + g + ";" + b + "m";

			case BgBasic(i) if (support >= 1): "\x1b[" + (40 + i) + "m";
			case BgBright(i) if (support >= 1): "\x1b[" + (100 + i) + "m";
			case BgAnsi256(i) if (support >= 2): "\x1b[48;5;" + i + "m";
			case BgRgb(r, g, b) if (support >= 3): "\x1b[48;2;" + r + ";" + g + ";" + b + "m";
			
			case ClearScreen if (support >= 0): "\x1b[H\x1b[2J";
			case ClearLine if (support >= 0): "\r\x1b[2K";
			case ClearScroll if (support >= 0): "\x1b[3J";
			case ScrollUp if (support >= 0): "\x1b[S";
			case ScrollDown if (support >= 0): "\x1b[T";
			case Bell if (support >= 0): "\x07";
			case HideCursor if (support >= 1): "\x1b[?25l";
			case ShowCursor if (support >= 1): "\x1b[?25h";
			case SaveCursor if (support >= 1): "\x1b[s\x1b7";
			case RestoreCursor if (support >= 1): "\x1b[u\x1b8";
			case EnterAltBuffer if (support >= 2): "\x1b[?1049h";
			case LeaveAltBuffer if (support >= 2): "\x1b[?1049l";
			
			case Custom(cmd): cmd;

			default: "";
		}
	}
}
