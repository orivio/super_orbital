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
	float mask = (1. - smoothstep(size, size+thickness, length(UV - center))) *
		smoothstep(size-thickness*2., size-thickness, length(UV - center));
	vec2 disp = normalize(UV - center) * force * mask;
	COLOR = texture(screen_texture, SCREEN_UV - disp);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
