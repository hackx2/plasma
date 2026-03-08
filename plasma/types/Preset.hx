package plasma.types;

enum Preset {
	/** Text modifier preset */
	Modifier(name:String, expr:Style, ?aliases:Array<String>);

	/** Foreground preset. */
	Foreground(name:String, expr:Style, ?aliases:Array<String>);

	/** Background preset. */
	Background(name:String, expr:Style, ?aliases:Array<String>);
}
