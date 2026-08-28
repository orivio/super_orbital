shader_type canvas_item;


uniform float scale;
uniform vec4 color : source_color;
uniform float variation;
uniform float distortion;
uniform float distortion_scale;
uniform vec2 offset;
uniform vec2 camera_offset;


float rand(float n){return fract(sin(n) * 43758.5453123);}
float rand(vec2 n) { 
	return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}
float noise(float p){
	float fl = floor(p);
  float fc = fract(p);
	return mix(rand(fl), rand(fl + 1.0), fc);
}
	
float noise(vec2 n) {
	const vec2 d = vec2(0.0, 1.0);
  vec2 b = floor(n), f = smoothstep(vec2(0.0), vec2(1.0), fract(n));
	return mix(mix(rand(b), rand(b + d.yx), f.x), mix(rand(b + d.xy), rand(b + d.yy), f.x), f.y);
}


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 base = color.rgb;
	vec2 uv = UV;
	uv += offset;
	uv += camera_offset * SCREEN_PIXEL_SIZE * vec2(0., 0.);
	uv = uv + vec2(noise(uv * distortion_scale + vec2(-82.3, 21.5)) * distortion, noise(uv * distortion_scale + vec2(-80., 10.)) * distortion);
	float brightness = noise(uv * scale) * variation - variation / 2.;
	base += brightness;
	COLOR = vec4(base, 1);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
