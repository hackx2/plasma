package plasma.internal;

import plasma.types.Ansi;
import plasma.types.Range;
import plasma.types.Style;

@:nullSafety(Strict)
final class Impl {
	@:noCompletion
	inline function new(?styles:Array<Style>, ?level:Int):Void{
		this.styles = styles ?? [];
		this._supportLevel = level ?? -1;
	}

	var styles:Array<Style>;
	@:noCompletion var _supportLevel:Null<Range<-1, 3>>;

	/**
	 * Compiles the provided arguments into an ANSI string sequence.
	 * @param args The arguments you want to compile.
	 */
	public function compile(args:Array<Dynamic>):Ansi {
		if (args.length == 0)
			return "";

		final buf:StringBuf = new StringBuf();
		for (i in 0...args.length) {
			buf.add(args[i]);
			if (i < args.length - 1)
				buf.add(" ");
		}
		return Renderer.render(buf.toString(), this.styles, _supportLevel ?? cast -1);
	}

	/**
	 * Appends the provided style to the existing list.
	 */
	public function apply(style:Style):Impl {
		final s:Array<Style> = this.styles.copy(); s.push(style);
		return new Impl(s, _supportLevel);
	}
}
