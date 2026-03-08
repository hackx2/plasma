package plasma.macros;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

import plasma.haxe.EitherType;
import plasma.macros.TypeTools.extract;
import plasma.macros.TypeTools.getConstValue;
import plasma.macros.TypeTools.isFloatType;

using haxe.macro.Tools;

@:nullSafety(Strict)
final class RangeBuilder {
	static inline final NAME:String = "Range";
	static final PACK:Array<String> = ["plasma", "_num_ranges"];

	@:noUsing public static function build():ComplexType {
		final localType = Context.getLocalType();
		return switch localType {
			case TInst(_, [min, max]):
				final isFloat:Bool = isFloatType(min) || isFloatType(max);
				final type:Type = Context.getType(isFloat ? "Float" : "Int");
				final name:String = NAME + "_" + (getConstValue(min) + "_" + getConstValue(max));

				try { // If we've already generated the type, return it.
					return Context.getType(PACK.join(".") + "." + name).toComplexType();
				} catch (_) {
					// Generate the Range type.
					return generate(name, localType, type, min, max);
				}
			default:
				Context.error("Range<Min, Max> requires two parameters", Context.currentPos());
		};
	}

	static function generate(name:String, localType:Type, t:Type, min:Type, max:Type):ComplexType {
		final p:Position = Context.currentPos();

		final ct:Null<ComplexType> = t.toComplexType(), selfType:Null<ComplexType> = localType.toComplexType();
		final min:TNumericConstraintExpr = extract(min), max:TNumericConstraintExpr = extract(max);

		final typeName:String = t.toString();
		final oppositeType:ComplexType = TPath({pack: [], name: typeName == "Float" ? "Int" : "Float"});

		Context.defineType({
			pack: PACK,
			name: name,
			pos: p,
			kind: TDAbstract(ct, null, null, [ct]),
			fields: (macro class {
				inline function new(v:$ct):Void {
					this = cast v;
				}

				@:from @:noCompletion
				static inline function from(v:$ct):$selfType {
					if (v < $min) @:pos(p) throw 'Value ' + v + " is below minimum value of " + $min;
					if (v > $max) @:pos(p) throw 'Value ' + v + " exceeds maximum value of " + $max;
					return cast(v : Dynamic);
				}

				// a hacky way (?) to override the error message thrown when the wrong type is given.
				// i'm not too sure if i'm using `:pos` correctly here.. :c
				@:from @:noCompletion
				static inline function err(v:$oppositeType):$selfType {
					@:pos(p) throw $v{oppositeType.getParameters()[0].name} + " should be " + $v{typeName};
				}
			}).fields,
			meta: [{name: ":noCompletion", pos: p}, #if cpp {name: ":unreflective", pos: p} #end]
		});
		
		return TPath({pack: PACK, name: name});
	}
}

@:noCompletion private typedef TNumericConstraintExpr = ExprOf<EitherType<Int, Float>>;
#end
