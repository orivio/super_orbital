shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float center_radius : hint_range(0.0, 0.5);
uniform float center_thickness : hint_range(0.0, 0.5);
uniform float displacement_scale : hint_range(0.0, 5.0);
uniform float displacement_magnitude : hint_range(0.0, 2.0);
uniform sampler2D distortion_curve;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float aspect_ratio = SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;
	vec2 scaled_uv = UV;
	scaled_uv.x -= 0.5;
	//scaled_uv *= vec2(aspect_ratio, 1.0);
	scaled_uv.x += 0.5;
	
	vec2 to_center = scaled_uv - vec2(0.5, 0.5);
	float distance_to_center = length(to_center);
	
	vec2 distortion_curve_coordinate = vec2(distance_to_center, 0.0) * displacement_scale;
	float displacement_strength = texture(distortion_curve, distortion_curve_coordinate).r * displacement_magnitude;
	
	vec2 displacement = normalize(to_center) * displacement_strength;
	
	COLOR = texture(screen_texture, SCREEN_UV - displacement);
	
	float center_mask = smoothstep(center_radius, center_radius - center_thickness, distance_to_center);
	COLOR.rgb -= vec3(center_mask);
	
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
