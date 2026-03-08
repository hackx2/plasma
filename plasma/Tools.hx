package plasma;

import plasma.types.Rgb;
import plasma.haxe.EitherType;

@:nullSafety(Strict)
final class Tools {
	@:noUsing public static function toRgb(color:EitherType<Int, String>):Rgb {
		var intColor:Int = 0;

		if (Std.isOfType(color, Int)) {
			intColor = cast color;
		} else if (Std.isOfType(color, String)) {
			var hex:String = cast(color, String);
			hex = StringTools.trim(hex);

			if (StringTools.startsWith(hex, "#")) {
				hex = hex.substring(1);
			}
			if (StringTools.startsWith(hex, "0x")) {
				hex = hex.substring(2);
			}

			final parsedInt = Std.parseInt("0x" + hex);
			if (parsedInt == null) {
				throw 'An invalid hexadecimal has been given: $hex';
			}
			intColor = parsedInt;
		} else {
			throw 'Invalid type given. Must be an `Int` or `String`-based hexadecimal.';
		}

		return {
			r: (intColor >> 16) & 0xFF,
			g: (intColor >> 8) & 0xFF,
			b: intColor & 0xFF
		}
	}
}
