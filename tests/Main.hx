import plasma.types.Ansi;
import plasma.Renderer;
import plasma.Plasma;

class Main {
	static function main() {
		final plasma = new Plasma({level: AUTO_DETECT});

		trace("--- Custom Color ---");

		trace(plasma.bgRgb(147, 111, 217).rgb(174, 241, 121).bold.apply(' Qzip '));
		trace(plasma.hex(0xDEADED).bold.apply(' Pink Meow! '));

		#if nodejs
		Sys.println(plasma.bgAnsi256(235).rgb(255, 228, 153).bold.apply(' Or') + plasma.bgAnsi256(235).ansi256(159).bold.apply('bl '));
		#else
		trace(plasma.bgAnsi256(235).rgb(255, 228, 153).bold.apply(' Or') + plasma.bgAnsi256(235).ansi256(159).bold.apply('bl '));
		#end

		trace("--- Chained Styles ---");
		trace(plasma.bgBlack.white.bold.apply(' Black & White '));

		trace("--- Color Nesting ---");

		trace(plasma.yellow.bold.apply('Mrraow', 'Meow', 'Mrrp', 'Nya', 'Mlem'));
		trace(plasma.yellow.bold.apply('Hello' + plasma.reset.bold.apply(','), plasma.bold.pink.apply('Cutie') + plasma.yellow.apply('!')));

		trace("--- @:op ---");

		#if nodejs
		Sys.println((new Plasma().bgHex("#00FF00") + " Meow ") + " Mrrp.");
		#else
		trace((new Plasma().bgHex("#00FF00") + " Meow ") + " Mrrp.");
		#end

		final red:Plasma = new Plasma().hex(0xFF0000);
		final bold:Plasma = new Plasma().bold;
		final alertStyle:Plasma = red + bold;

		trace(alertStyle + "CRITICAL MEOW DETECTED" + (Plasma.instance.reset.bold.white.rapidBlink + " ...maybe"));

		trace("--- Testing Ansi Abstract ---");

		final styledText:Ansi = plasma.bold.red.apply("Visible Meow");
		trace("Raw length: " + (cast styledText : String).length);
		trace("Visible length: " + styledText.length);

		trace("--- Renderer ---");
		trace(Renderer.render('Mrraow', [Underline, Bold, FgBasic(5)]));
		trace("Italic Text: " + Renderer.style(Italic) + "italic meow" + Renderer.style(Reset));
	}
}
