shader_type spatial;
render_mode cull_disabled, unshaded, shadows_disabled;

uniform sampler2D alpha_gradient;
uniform sampler2D noise;
uniform vec2 speed;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = COLOR.rgb;
	ALPHA = COLOR.a * texture(alpha_gradient,UV).r * texture(noise, UV+TIME*speed).r;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
