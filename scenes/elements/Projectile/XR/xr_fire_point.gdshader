shader_type spatial;

uniform sampler2D noise1;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float unknown = .0;
	if (UV.g < .6) {
		unknown = (0.7 - UV.g)*2.;
		if (texture(noise1, UV + TIME/3.).r < unknown) {
			ALPHA = 0.0;
		} 
	}
	ALBEDO.g = 1. - UV.g;
	ALBEDO.b = 0.0;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
