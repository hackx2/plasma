package plasma.types;

#if (haxe_ver >= 4.0) enum #else @:enum #end abstract SupportLevel(Int) from Int to Int {
	/** Automatically detect the support level.*/
	final AUTO_DETECT:SupportLevel = -1;

	/** Fully disable everything. */
	final DISABLED:SupportLevel = 0;

	final BASIC_COLOR:SupportLevel = 1;
	final ANSI_COLOR:SupportLevel = 2;
	final TRUE_COLOR:SupportLevel = 3;
}
