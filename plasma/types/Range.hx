package plasma.types;

import plasma.haxe.EitherType;

/**
 * Using this class generates a unique, *generic*, *macro-generated* abstract designed to constrain numerical values, during both 
 * compilation and runtime, within a specified `Min` and `Max` range.
 * 
 * For example,
 * ```haxe
 * function test(v1:Range<2, 10>):Void {}
 * 
 * test(2);  // An error is not thrown.     |         Value 2 passes (2 < x <= 10).
 * test(11); // An error is thrown.         |         Value 11 exceeds the maximum value of 10.
 * test(1)   // An error is thrown.         |         Value 1 is below the minimum value of 2.
 * ```
 * 
 * _On rare occasions, it may be **necessary** to explicitly cast the returned value to your desired numerical type._
 */
@:genericBuild(plasma.macros.RangeBuilder.build()) // if you're going to use this, please credit accordingly. :D
final class Range<@:const Min:NumericTypes, @:const Max:NumericTypes> {}

@:noCompletion private typedef NumericTypes = EitherType<Int, Float>;
