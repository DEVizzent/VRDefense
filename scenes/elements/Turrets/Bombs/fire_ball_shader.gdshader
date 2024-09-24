shader_type spatial;

uniform sampler2D noise1;
uniform sampler2D noise3;
uniform sampler2D noise2;

uniform vec4 color_base: source_color;

void fragment() {
	float nivel_rojo = mix(texture(noise1, UV + TIME/9.), texture(noise2, UV - TIME/7.), .5).r;
	float nivel_green = texture(noise2, UV - TIME/8.).g;
	vec3 color_final = vec3(color_base.r * nivel_rojo, color_base.g * nivel_green * nivel_rojo, 0);
	ALBEDO = color_final;
}
