shader_type spatial;
render_mode unshaded, depth_draw_never, skip_vertex_transform;

uniform vec4 shine_color : source_color = vec4( 1.0, 1.0, 1.0, 1.0 );
const float shine_speed = 1.5;
uniform float size = 1.999;
uniform float shine_width : hint_range(5.0, 200.0, 5) = 50.0;

float calculate_frequency_for(float vertex, float width) {
	return floor(abs(cos( vertex / 2.3 + TIME * shine_speed)) + width) + floor(abs(sin( vertex / 2.3 + TIME * shine_speed)) + width);
}
void vertex() {
	VERTEX = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
    NORMAL = normalize((MODELVIEW_MATRIX * vec4(NORMAL, 0.0)).xyz);
    BINORMAL = normalize((MODELVIEW_MATRIX * vec4(BINORMAL, 0.0)).xyz);
    TANGENT = normalize((MODELVIEW_MATRIX * vec4(TANGENT, 0.0)).xyz);
}

void fragment( )
{
	vec3 vertex = VERTEX - NODE_POSITION_VIEW;
	
	float width = shine_width * 0.001;
	float frequency = 0.0;
	
	if (vertex.x < size && vertex.x > -size) {
		if (vertex.z > 0.) {
			frequency = calculate_frequency_for(-vertex.x, width);
		} else {
			frequency = calculate_frequency_for(vertex.x, width);
		}
	} else {
		if (vertex.x > 0.) {
			frequency = calculate_frequency_for(vertex.z, width);
		} else {
			frequency = calculate_frequency_for(-vertex.z, width);
		}
	}
	
	ALBEDO = shine_color.rgb;
	ALPHA = frequency;
}