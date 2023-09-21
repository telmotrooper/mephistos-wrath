shader_type spatial;
uniform float strength;

void fragment() {
	ALBEDO = vec3(0.8, 1.0, 0.0);
	ALPHA = strength;
}
