shader_type canvas_item;
render_mode unshaded;

uniform bool gravity_on = true;
uniform vec4 gravity_color : source_color;
uniform vec4 nogravity_color : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    vec4 base_color = texture(TEXTURE, UV);
	vec4 outline_color = vec4(0.0, 0.0, 0.0, 0.0);
	if(gravity_on) {
		outline_color = gravity_color;
	}
	else {
		outline_color = nogravity_color;
	}
	
	vec2 size = TEXTURE_PIXEL_SIZE * 2.0;
	
	
	
    COLOR = vec4(base_color);
	float right_neighbor = texture(TEXTURE, UV + vec2(size.x, 0.0)).a;
	float left_neighbor = texture(TEXTURE, UV + vec2(-size.x, 0.0)).a;
	float top_neighbor = texture(TEXTURE, UV + vec2(0.0, size.y)).a;
	float bottom_neighbor = texture(TEXTURE, UV + vec2(0.0, -size.y)).a;
	
	float max_alpha = base_color.a;
	max_alpha = max(max_alpha, right_neighbor);
	max_alpha = max(max_alpha, left_neighbor);
	max_alpha = max(max_alpha, top_neighbor);
	max_alpha = max(max_alpha, bottom_neighbor);
	
	COLOR = vec4(mix(outline_color, base_color, base_color.a).rgb, clamp(max_alpha, 0.0, 1.0));
	
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
