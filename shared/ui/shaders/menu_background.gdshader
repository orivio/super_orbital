shader_type canvas_item;

float rand(float co) {
    return fract(sin(co * 91.3458) * 47453.5453);
}

void vertex() {
}

void fragment() {
	vec2 cell = floor(UV * 20.0);
	float starpos_x = rand(cell.x) / 20.0 + UV.x;
	float starpos_y = rand(cell.y) / 20.0 + UV.y;
	vec2 starpos = vec2(starpos_x, starpos_y);
	float dist = 0.01;
	if(distance(starpos, UV.xy) < dist) {
		COLOR = vec4(1, 1, 1, 1);
	}
	else {
		COLOR = vec4(0, 0, 0, 1);
	}
	COLOR = vec4((starpos - UV * 1.0) * 10.0, 0, 1);
	
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
