package plasma.haxe;

/**
 * An **non-extern-based** alternative to `haxe.extern.EitherType`, allowing 
 * values to be either of `T1` or `T2` type.
 * 
 * @see <https://api.haxe.org/haxe/extern/EitherType.html>
 */
@:transitive abstract EitherType<T1, T2>(Dynamic) from T1 from T2 to T1 to T2 {}