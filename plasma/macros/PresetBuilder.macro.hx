package plasma.macros;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;

import plasma.types.Style;
import plasma.Constants.presets;

@:nullSafety(Strict)
final class PresetBuilder {
	@:noUsing public static macro function build():Array<Field> {
		final fields:Array<Field> = Context.getBuildFields();
		final pos:Position = Context.currentPos();

		for (preset in presets) {
			if (preset == null) continue;

			var name:String;
			var styleExpr:Style;
			var aliases:Array<String>;

			switch preset {
				case Modifier(n, e, a) | Foreground(n, e, a) | Background(n, e, a):
					name = n;
					styleExpr = e;
					aliases = a != null ? a : [];
			}

			final stylePresets:Array<String> = [name].concat(aliases);

			for (alias in stylePresets) {
				fields.push({
					name: alias,
					access: [APublic, AFinal],
					kind: FProp("get", "never", macro :Plasma),
					pos: pos,
					doc: '_${preset.getName()}_: apply `${stylePresets.length > 1 ? alias == name ? '$alias' : '$alias ($name)' : alias}` style.',
				});

				fields.push({
					name: 'get_${alias}',
					access: [AInline, APrivate],
					kind: FFun({
						expr: macro return applyStyle($v{styleExpr}),
						ret: macro :Plasma,
						args: []
					}),
					pos: pos,
					meta: [{name: ":noCompletion", pos: pos}]
				});
			}
		}
		return fields;
	}
}
#end
