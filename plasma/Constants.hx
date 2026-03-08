package plasma;

import plasma.types.Preset;

@:publicFields
final class Constants {
	/**
	 * An EReg-based way to identify ANSI escape sequences.
	 * @see <https://github.com/chalk/ansi-regex/blob/main/index.js>
	 */
	static final ANSI_PATTERN:EReg = {
		final ST:String = "(?:\\x07|\\x1B\\\\|\\x9C)";
		final osc:String = "(?:\\x1B\\][\\s\\S]*?" + ST + ")";
		final csi:String = "[\\x1B\\x9B][[\\]()#;?]*(?:\\d{1,4}(?:[;:]\\d{0,4})*)?[\\dA-PR-TZcf-nq-uy=><~]";
		new EReg(osc + "|" + csi, "g");
	}

	static var presets:Array<Preset> = [
		/** Modifier(s) */
		Modifier("reset", Reset, ['strong']),
		Modifier("bold", Bold, ["Strong"]),
		Modifier("dim", Dim, ["faint"]),
		Modifier("italic", Italic),
		Modifier("underline", Underline, ["underlined"]),
		Modifier("overline", Overline),
		Modifier("inverse", Inverse, ["invert", "reverse"]),
		Modifier("hidden", Hidden, ["conceal"]),
		Modifier("strikethrough", Strikethrough),
		Modifier("visible", Visible),
		Modifier("rapidBlink", RapidBlink),
		Modifier("slowBlink", SlowBlink),
		Modifier("doubleUnderline", DoubleUnderline),
		/** Foreground Color(s) */
		Foreground("black", FgBasic(0), []),
		Foreground("red", FgBasic(1), []),
		Foreground("green", FgBasic(2), []),
		Foreground("yellow", FgBasic(3), []),
		Foreground("blue", FgBasic(4), []),
		Foreground("magenta", FgBasic(5), ["pink"]),
		Foreground("cyan", FgBasic(6), ["aqua"]),
		Foreground("white", FgBasic(7), []),
		Foreground("blackBright", FgBright(0), ["gray", "grey"]),
		Foreground("redBright", FgBright(1), []),
		Foreground("greenBright", FgBright(2), []),
		Foreground("yellowBright", FgBright(3), []),
		Foreground("blueBright", FgBright(4), []),
		Foreground("magentaBright", FgBright(5), ["pinkBright"]),
		Foreground("cyanBright", FgBright(6), ["aquaBright"]),
		Foreground("whiteBright", FgBright(7), []),
		/** Background Color(s) */
		Background("bgBlack", BgBasic(0), []),
		Background("bgRed", BgBasic(1), []),
		Background("bgGreen", BgBasic(2), []),
		Background("bgYellow", BgBasic(3), []),
		Background("bgBlue", BgBasic(4), []),
		Background("bgMagenta", BgBasic(5), ["bgPink"]),
		Background("bgCyan", BgBasic(6), ["bgAqua"]),
		Background("bgWhite", BgBasic(7), []),
		Background("bgBlackBright", BgBright(0), ["bgGray", "bgGrey"]),
		Background("bgRedBright", BgBright(1), []),
		Background("bgGreenBright", BgBright(2), []),
		Background("bgYellowBright", BgBright(3), []),
		Background("bgBlueBright", BgBright(4), []),
		Background("bgMagentaBright", BgBright(5), ["bgPinkBright"]),
		Background("bgCyanBright", BgBright(6), ["bgAquaBright"]),
		Background("bgWhiteBright", BgBright(7), [])
	];
}
