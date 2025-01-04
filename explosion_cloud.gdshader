shader_type spatial;

uniform sampler2D vertex_noise;
uniform float cloud_speed : hint_range( 0.0, 1.0 ) = .25;
uniform float cloud_intensity : hint_range( 0.0, 1.0 ) = .25;

uniform sampler2D cloud_color;
uniform sampler2D gradient;

uniform vec3 emission_color : source_color;
uniform float emission_intensity : hint_range(0.0, 30.0, 1.0) = 20.0;
uniform sampler2D emission_noise;
uniform float emission_amount : hint_range( 0.0, 1.0 ) = .0;

uniform sampler2D alpha_noise;
uniform float alpha_amount : hint_range(0.0, 1.0) = .0;
float _proximity_fade(float fade_dst, vec3 vertex, sampler2D depth_texture, vec2 screen_uv, mat4 inv_proj_matrix) {
	float depth = textureLod(depth_texture, screen_uv, 0.0).r;
	vec4 world_pos = inv_proj_matrix * vec4(screen_uv*2.0-1.0, depth, 1.0);
	world_pos.xyz /= world_pos.w;

	return clamp(1. - smoothstep(world_pos.z + fade_dst, world_pos.z, vertex.z), 0.0, 1.0);
}

void vertex() {
	VERTEX += texture(vertex_noise, UV+TIME*cloud_speed).r*cloud_intensity*NORMAL;
}

void fragment() {
	ALBEDO = texture(cloud_color, UV).r * texture(gradient, UV).rgb;
	EMISSION = smoothstep(COLOR.r, 1, texture(emission_noise, UV).r) * emission_color * emission_intensity;
	ALPHA = smoothstep(COLOR.a, 1.0, texture(alpha_noise, UV).r);
}
