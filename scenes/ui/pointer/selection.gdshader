shader_type spatial;
render_mode unshaded, depth_draw_never;

uniform vec4 shine_color : source_color = vec4( 1.0, 1.0, 1.0, 1.0 );
const float shine_speed = 1.5;
uniform float size = 1.999;
uniform float shine_width : hint_range(5.0, 200.0, 5) = 50.0;

float calculate_frequency_for(float vertex, float width) {
	return floor(abs(cos( vertex / 2.3 + TIME * shine_speed)) + width) + floor(abs(sin( vertex / 2.3 + TIME * shine_speed)) + width);
}

void fragment( )
{
	vec3 vertex = VERTEX - NODE_POSITION_WORLD;
	
	float width = shine_width * 0.001;
	float frequency = 0.0;
	
	if (vertex.x < 1.99 && vertex.x > -1.99) {
		if (vertex.y > 0.) {
			frequency = calculate_frequency_for(vertex.x, width);
		} else {
			frequency = calculate_frequency_for(-vertex.x, width);
		}
	} else {
		if (vertex.x > 0.) {
			frequency = calculate_frequency_for(-vertex.y, width);
		} else {
			frequency = calculate_frequency_for(vertex.y, width);
		}
	}
	
	ALBEDO = shine_color.rgb;
	ALPHA = frequency;
}