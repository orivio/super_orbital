shader_type canvas_item;

uniform float pixel_size = 8.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	
	float grid = pixel_size;
	
	vec2 u = floor(UV * grid) / grid;
	u = UV;
	
	float d = distance(u, vec2(0.5, 0.5));
	d *= 1.;
	COLOR = vec4(0, 0, 0, 1.0 - (d) * 2.);
	
	float rad = 0.5;
	float w = 0.01;
	
	/*if(d < rad + w && d > rad - w) {
		COLOR = vec4(0, 0, 0, 1);
	}*/
	
	
	//COLOR = vec4(u, vec2(0.0, 1.0));
	
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
