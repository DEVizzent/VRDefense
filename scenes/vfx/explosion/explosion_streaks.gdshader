shader_type spatial;
render_mode cull_disabled, unshaded;
uniform sampler2D streaks_texture;
uniform vec4 streaks_color: source_color;
uniform sampler2D alpha_noise;
uniform float alpha_amount : hint_range(0.0, 1.0) = .0;

float random (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float part = ceil(COLOR.r*4.0)/4.;
	vec2 split_uv_texture = vec2(part+UV.x*.25,UV.y);
	ALBEDO = streaks_color.rgb;
	ALPHA = texture(streaks_texture, split_uv_texture).r * smoothstep(COLOR.a, 1., texture(alpha_noise, UV).r);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
