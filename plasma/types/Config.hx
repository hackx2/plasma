package plasma.types;

/**
 * Plasma Support Levels:
 * - `-1` / `AUTO_DETECT` - Auto-detect support level.
 * - `0` / `DISABLED` - All colors disabled.
 * - `1` / `BASIC_COLOR` - Basic 16 colors support.
 * - `2` / `ANSI_COLOR` - ANSI 256 colors support.
 * - `3` / `TRUE_COLOR` - Truecolor 16 million colors support.
 */
typedef Config = {
	level:SupportLevel
}
