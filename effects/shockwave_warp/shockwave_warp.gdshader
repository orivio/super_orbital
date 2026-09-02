shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float force : hint_range(0.0, 2.0);
uniform float size : hint_range(0.0, 2.0);
uniform float thickness: hint_range(0.0, 0.2);
uniform vec2 center;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float aspect_ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	vec2 true_uv = (SCREEN_UV - vec2(0.5, 0.0)) / vec2(aspect_ratio, 1.0) + vec2(0.5, 0.0);
	float mask = (1. - smoothstep(size, size+thickness, length(true_uv - center))) *
		smoothstep(size-thickness*2., size-thickness, length(true_uv - center));
	vec2 disp = normalize(true_uv - center) * force * mask;
	COLOR = texture(screen_texture, SCREEN_UV - disp);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
