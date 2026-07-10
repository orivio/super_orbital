shader_type canvas_item;

uniform float scale = 1.0;
uniform vec2 speed = vec2(0.0, 0.0);
uniform float pixel_size : hint_range(1.0, 64.0) = 8.0;

uint pcg(uint v) {
    uint state = v * 747796405u + 2891336453u;
    uint word = ((state >> ((state >> 28u) + 4u)) ^ state) * 277803737u;
    return (word >> 22u) ^ word;
}
float random(vec2 p) {
    uint see = uint(p.x) + uint(p.y) * 1973u;
    return float(pcg(see)) / 4294967295.0;
}
/*float random(vec2 st) {
	return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}*/

// Based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float noise (in vec2 _st) {
    vec2 i = floor(_st);
    vec2 f = fract(_st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

#define NUM_OCTAVES 5

float fbm ( in vec2 _st) {
    float v = 0.0;
    float a = 0.5;
    vec2 shift = vec2(100.0);
    // Rotate to reduce axial bias
    mat2 rot = mat2(vec2(cos(0.5), sin(0.5)), vec2(-sin(0.5), cos(0.50)));
    for (int i = 0; i < NUM_OCTAVES; ++i) {
        v += a * noise(_st);
        _st = rot * _st * 2.0 + shift;
        a *= 0.5;
    }
    return v;
}



float rand(float co) {
    return fract(sin(co * 81.3428) * 47516.5413);
}
vec2 rand_vec2(vec2 co) {
	return vec2(rand(co.x), rand(co.y));
}
float map(float value, float min1, float max1, float min2, float max2) {
  return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}

void vertex() {
}

void fragment() {
	
    /*vec2 uv_derivatives = fwidth(UV);
    float aspect_ratio = uv_derivatives.y / uv_derivatives.x;
	vec2 u = UV * 0.5;
	u.x *= aspect_ratio;
	float space_quantization = 80.0;
	u = floor(u * space_quantization) / space_quantization;*/
	
	vec2 screen_resolution = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 grid = screen_resolution / pixel_size;
	vec2 u = floor(SCREEN_UV * grid) / grid;
	vec2 uv = vec2(u.x + fbm(u) * 1.1 + 1000.0, u.y + fbm(u));
	
	float fb = fbm(uv * scale + TIME * speed);
	float fbna = clamp(fb * 1.3, 0.0, 1.5) - 0.3;
	float fba = clamp(fb * 1.6, 0.0, 1.4) - 0.4;
	
	float fbmr = fbm(uv * 0.5 * scale + TIME * speed * 2.3) * 0.8;
	float fbmg = fbm(uv * 0.5 * scale + TIME * speed * 1.3) * 0.2;
	float fbmb = fbm(uv * 0.5 * scale + TIME * speed * 1.9) * 1.0;
	COLOR = vec4(fbmr * fbna, fbmg * fbna, fbmb * fbna, fba);
	
	float color_quantization = 10.0;
	COLOR = floor(COLOR * color_quantization) / color_quantization;
	//COLOR = vec4(fba);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
