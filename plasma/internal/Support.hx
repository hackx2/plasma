package plasma.internal;

/**
 * @see <https://github.com/chalk/chalk/blob/main/source/vendor/supports-color/index.js>
 */
@:nullSafety(Strict)
final class Support {
	/**
	 * Allows for a global manual override of the detected support level. \
	 * _Set to `-1` to for automatic detection_
	 */
	public static var supportBypass:Int = -1;

	@:noCompletion
	static var _cachedSupport:Int = -1;

	@:noCompletion
	static var _envCache:Null<Map<String, String>> = null;

	/**
	 * The determined ANSI support level of the current environment.
	 * 
	 * Support Level: \
	 * `-1` :  Auto-detect \
	 * `0`  :  Disabled \
	 * `1`  :  Basic (16 colors) \
	 * `2`  :  256 colors \
	 * `3`  :  TrueColor
	 */
	public static var support(get, never):Int;

	@:noCompletion inline static function get_support():Int {
		if (_cachedSupport != -1)
			return _cachedSupport;
		_cachedSupport = (supportBypass >= 0) ? supportBypass : supportsColor();
		return _cachedSupport;
	}

	@:noUsing public static function supportsColor():Int {
		if (_envCache == null)
			_envCache = Sys.environment();
		final env = _envCache;

		final force:Null<String> = env.get("FORCE_COLOR");
		if (force != null) {
			final p:Null<Int> = Std.parseInt(force);
			return (p == null || p > 3) ? 1 : p;
		}

		if (env.exists("TF_BUILD") && env.exists("AGENT_NAME"))
			return 1;
		if (env.get("TERM") == "dumb")
			return 0;

		if (env.exists("CI")) {
			if (env.exists("GITHUB_ACTIONS") || env.exists("GITEA_ACTIONS"))
				return 3;
			if (env.exists("TRAVIS") || env.exists("APPVEYOR") || env.exists("GITLAB_CI") || env.exists("BUILDKITE") || env.exists("DRONE")
				|| env.get("CI_NAME") == "codeship") {
				return 1;
			}
			return 0;
		}

		if (env.exists("TEAMCITY_VERSION"))
			@:nullSafety(Off) {
			return ~/^(9\.|[1-9]\d+\.)/.match(env.get("TEAMCITY_VERSION")) ? 1 : 0;
		}

		if (env.get("COLORTERM") == "truecolor")
			return 3;

		final termProg:Null<String> = env.get("TERM_PROGRAM");
		if (termProg != null) {
			switch termProg {
				case "iTerm.app":
					final version:Null<String> = env.get("TERM_PROGRAM_VERSION");
					return @:nullSafety(Off) (version != null && Std.parseInt(version.split(".")[0]) >= 3) ? 3 : 2;
				case "Apple_Terminal":
					return 2;
				case "vscode":
					return 3;
			}
		}

		final term:Null<String> = env.get("TERM");
		if (term != null) {
			switch term {
				case "xterm-kitty", "xterm-ghostty", "wezterm":
					return 3;
			}
			if (StringTools.endsWith(term, "-256color") || StringTools.endsWith(term, "-256"))
				return 2;
			@:nullSafety(Off) if (~/^(screen|xterm|vt100|vt220|rxvt|color|ansi|cygwin|linux)/i.match(term))
				return 1;
		}

		if (env.exists("COLORTERM"))
			return 1;

		#if sys
		// The modern Windows 11 terminal supports Truecolor,
		// so we're going to give it the highest level of support
		if (Sys.systemName() == "Windows")
			return 3;
		#end

		return 0;
	}
}
