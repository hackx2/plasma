package plasma;

import haxe.ds.ReadOnlyArray;

import plasma.types.Rgb;
import plasma.types.Ansi;
import plasma.types.Style;
import plasma.types.Range;
import plasma.types.Config;

import plasma.types.Preset;
import plasma.internal.Impl;
import plasma.haxe.EitherType;

/**
 * This **abstract** provides a clean and intuitive way to chain _various_ styles
 * and **modifiers** together to create a styled **ANSI** sequence-based string.
 * 
 * Make sure to add `.apply(<STRING>)` with a string argument at the end of the chain.
 * 
 * The order in which you apply such styles doesn't matter, due to later styles taking
 * precedent in case of a **conflict**. \
 * _This simply means that `plasma.red.green.blue` is the equivalent to `plasma.blue`._
 * 
 * @see <https://en.wikipedia.org/wiki/ANSI_escape_code>
 */
@:nullSafety(Strict)
@:access(plasma.internal.Impl)
@:forward(styles, render, _supportLevel)
@:build(plasma.macros.PresetBuilder.build())
abstract Plasma(Impl) {
	/**
	 * The default **Plasma** instance that allows you to chain _various_ styles together.
	 * 
	 * Make sure to add `.apply(<STRING>)` with a string argument at the end of the chain.
	 * 
	 * The order **doesn't** matter, and later styles take precedent in case of a **conflict**. \
	 * _This simply means that `plasma.red.green.blue` is equivalent to `plasma.blue`._
	 */
	public static var instance(default, null):Plasma = new Plasma();

	/**
	 * A quick-and-easy-to-use link to the `Terminal` utility class.
	 */
	public static var terminal(default, never) = Terminal;

	/**
	 * A **readonly** list of all available modifiers.
	 */
	public static var modifiers(get, never):ReadOnlyPresetArray;
	@:noCompletion 
	static function get_modifiers():ReadOnlyPresetArray {
		return Constants.presets.filter(_ -> _.match(Modifier(_, _, _)));
	}
	/**
	 * A **readonly** list of all available foreground colors.
	 */
	public static var foregroundColors(get, never):ReadOnlyPresetArray;
	@:noCompletion 
	static function get_foregroundColors():ReadOnlyPresetArray {
		return Constants.presets.filter(_ -> _.match(Foreground(_, _, _)));
	}

	/**
	 * A **readonly** list of all available background colors.
	 */
	public static var backgroundColors(get, never):ReadOnlyPresetArray;
	@:noCompletion 
	static function get_backgroundColors():ReadOnlyPresetArray {
		return Constants.presets.filter(_ -> _.match(Background(_, _, _)));
	}

	/**
	 * The color support for Plasma.
	 * 
	 * by default, color support is automatically detected based on the execution environment.
	 *  
	 * Levels:
	 * - `0` - All colors disabled.
	 * - `1` - Basic 16 colors support.
	 * - `2` - ANSI 256 colors support.
	 * - `3` - Truecolor 16 million colors support.
	 */
	public var level(get,set):Int;
	@:noCompletion 
	inline function get_level():Int {
		return this._supportLevel ?? cast -1;
	}
	@:noCompletion 
	inline function set_level(level:Int):Int {
		return this._supportLevel = cast(level, Range<-1, 3>);
	}

	
	/**
	 * Renders the given inputs as a styled string.
	 * @param args Arguments.
	 * @return Returns the rendered string.
	 */
	@:selfCall
	inline public function apply(args:...Dynamic):Ansi {
		return this.compile(args);
	}

	// --- FOREGROUND STYLES METHODS ---

	/**
	 * Sets the terminal foreground using Rgb channels.
	 * @param r Red Channel
	 * @param g Green Channel
	 * @param b Blue Channel
	 */
	inline public function rgb(r:Range<0, 255>, g:Range<0, 255>, b:Range<0, 255>):Plasma {
		return applyStyle(FgRgb(r, g, b));
	}

	/**
	 * Sets the terminal foreground using an ANSI-256 color code.
	 * @param c The ANSI-256 color code.
	 */
	inline public function ansi256(c:Range<0, 255>):Plasma {
		return applyStyle(FgAnsi256(c));
	}

	/**
	 * Sets the terminal foreground using a hexadecimal value.
	 * @param hex Either a `Int` or `String` hexadecimal value.
	 */
	inline public function hex(hex:EitherType<Int, String>):Plasma {
		final _rgb:Rgb = Tools.toRgb(hex);
		return rgb(_rgb.r, _rgb.g, _rgb.b);
	}

	// --- BACKGROUND STYLE METHODS  ---

	/**
	 * Sets the terminal background using Rgb channels.
	 * @param r Red Channel
	 * @param g Green Channel
	 * @param b Blue Channel
	 */
	inline public function bgRgb(r:Range<0, 255>, g:Range<0, 255>, b:Range<0, 255>):Plasma {
		return applyStyle(BgRgb(r, g, b));
	}

	/**
	 * Sets the terminal background using an ANSI-256 color code.
	 * @param c The ANSI-256 color code.
	 */
	inline public function bgAnsi256(c:Range<0, 255>):Plasma {
		return applyStyle(BgAnsi256(c));
	}

	/**
	 * Sets the terminal background using a hexadecimal value.
	 * @param hex Either an `Int` (`0xFFFFFF`) or `String` (`"#FFFFFF"`) hexadecimal value.
	 */
	inline public function bgHex(hex:EitherType<Int, String>):Plasma {
		final _rgb:Rgb = Tools.toRgb(hex);
		return bgRgb(_rgb.r, _rgb.g, _rgb.b);
	}

	// --- CONSTRUCTOR & HELPER METHODS ---

	@:access(plasma.internal.Impl)
	inline public function new(?settings:Config):Plasma {
		this = new Impl();
		this._supportLevel = cast settings?.level;
		this._supportLevel ??= -1;
	}

	@:op(A + B)
	inline static function applyToString(style:Plasma, str:String):Ansi {
		return style.apply(str);
	}

	@:op(A += B)
	inline static function addToInstance(A:Plasma, B:Plasma):Plasma {
		A._supportLevel = B._supportLevel;
		A.styles = A.styles.concat(B.styles);
		return A;
	}

	@:op(A -= B)
	inline static function subtractFromInstance(A:Plasma, B:Plasma):Plasma {
		var len:Int = A.styles.length;
		while (len-- > 0) {
			if (B.styles.contains(A.styles[len])) {
				A.styles.splice(len, 1);
			}
		}
		return A;
	}

	@:op(A + B)
	inline static function mergeInstances(A:Plasma, B:Plasma):Plasma {
		final p:Plasma = new Plasma();
		p.styles = A.styles.copy();
		p._supportLevel = B._supportLevel;
		for (i in B.styles) {
			p.styles.push(i);
		}
		return p;
	}

	@:op(A - B)
	inline static function subtractInstances(A:Plasma, B:Plasma):Plasma {
		final p:Plasma = new Plasma();
		p._supportLevel = A._supportLevel;
		p.styles = [for (s in A.styles) if (!B.styles.contains(s)) s];
		return p;
	}

	inline function applyStyle(style:Style):Plasma {
		return cast(this : Impl).apply(style);
	}
}

@:noCompletion
private typedef ReadOnlyPresetArray = haxe.ds.ReadOnlyArray<Preset>;