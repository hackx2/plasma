import haxe.Timer;

import plasma.Terminal;
import plasma.Plasma.instance as plasma;

enum State {
	Starting;
	Deleting;
	Final;
}

class Typewriter {
	static inline final init:String = "Meow- Mrraow.. maow.. meow";
	static inline final _final:String = "MRRAOWW~";

	static var index:Int = 0;
	static var state:State = Starting;

	static function main() {
		Terminal.hideCursor();

		final tmwr = new Timer(50);
		tmwr.run = () -> {
			switch state {
				case Starting:
					if (index < init.length) {
						Sys.print(plasma.bold.white.apply(init.charAt(index)));
						index++;
					} else {
						state = Deleting;
					}

				case Deleting:
					if (index > 0) {
						Terminal.execute(Custom("\x08 \x08"));
						index--;
					} else {
						state = Final;
					}

				case Final:
					if (index < _final.length) {
						Sys.print(plasma.bold.white.apply(_final.charAt(index)));
						index++;
					} else {
						tmwr.stop();
                        Terminal.beep();
						Terminal.showCursor();
						Sys.print("\n");
					}
			}

			#if sys
			Sys.stdout().flush();
			#end
		};
	}
}
