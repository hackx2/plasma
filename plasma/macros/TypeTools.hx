package plasma.macros;

#if macro
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;
import haxe.macro.ExprTools;

/**
 * A utils class for simplifying the process of using macro 
 * expressions and type parameters during compilation.
 */
@:nullSafety(Strict)
final class TypeTools {
	/**
	 * Retrieves the underlying Expr from a `:const` type parameter.
	 * @param t The type whose expr you're trying to get.
	 */
	inline public static function extract(t:Type):Null<Expr> {
		return switch t {
			case TInst(_.get() => {kind: KExpr(expr)}, _): expr;
			default: Context.error("Expected a literal constant", Context.currentPos());
		};
	}

	/**
	 * Converts a `:const` type parameter into a sanitized string.
	 * @param t The type you are trying to sanitize.
	 */
	inline public static function getConstValue(t:Type):Null<String> {
		return try {
			final value = ExprTools.getValue(extract(t));
			Std.string(value).split("-").join("n").split(".").join("_");
		} catch (error:Error) {
			Context.error("Unable to acquire :const value: " + error, Context.currentPos());
		}
	}

	/**
	 * Helper method to check if a macro Type is a Float constant
	 */
	public static function isFloatType(t:Type):Bool {
		final e:Null<Expr> = extract(t);
		if (e == null)
			return false;

		return switch e.expr {
			case EConst(CFloat(_)): true;
			default: false;
		}
	}
}
#end
