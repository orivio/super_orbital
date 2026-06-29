shader_type canvas_item;

uniform vec2 stars_speed = vec2(15.0, 0.0);
uniform float stars_density: hint_range(0.0, 1.0, 0.001) = 0.01;
uniform float star_size = 1.0;
uniform sampler2D star_texture;
uniform float seed = 0.0;

varying vec2 position;
uint pcg(uint v) {
    uint state = v * 747796405u + 2891336453u;
    uint word = ((state >> ((state >> 28u) + 4u)) ^ state) * 277803737u;
    return (word >> 22u) ^ word;
}
/*float random(vec2 st) {
	return fract(sin(dot(st, vec2(12.9898, 78.233))) * 43758.5453);
}*/
float random(vec2 p) {
    uint see = uint(p.x) + uint(p.y) * 1973u;
    return float(pcg(see)) / 4294967295.0;
}

void vertex() {
	position = VERTEX;
}

void fragment() {
	
	vec2 uv = (position + TIME * stars_speed) * TEXTURE_PIXEL_SIZE / star_size;
	uv = fract(uv) * step(random(floor(uv)), stars_density);
	COLOR = texture(TEXTURE, uv);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
