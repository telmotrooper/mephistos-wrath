shader_type spatial;
uniform vec3 tint_color: source_color;
uniform float strength;

void fragment() {
	ALBEDO = tint_color;
	ALPHA = strength;
}
