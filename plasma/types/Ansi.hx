package plasma.types;

/**
 * `Ansi` is an abstract that extends from haxe's base `String` class.
 * This abstract exposes all `String` APIs (including `Static` ones) removing the need to `cast`
 * 
 * String can be concatenated by using the `+` operator. If an operand is not a
 * String, it is passed through `Std.string()` first.
 * 
 * @see <https://haxe.org/manual/std-String.html>
 */
@:forward.new
@:forwardStatics // ehh..,- over do?
@:forward(toUpperCase, toLowerCase, charAt, charCodeAt, indexOf, lastIndexOf, split, substr, substring, toString)
abstract Ansi(String) from String to String {
	/**
	 * The length of `this` String instance (minus ANSI sequences).
	 */
	public var length(get, never):Int;

	@:noCompletion function get_length():Int {
		return Constants.ANSI_PATTERN.replace(this, "").length;
	}

	@:op(A + B)
	@:noCompletion
	static inline function add(a:Ansi, b:Ansi):Ansi {
		return new Ansi(cast(a, String) + cast(b, String)); // nuh uh...
	}
}
