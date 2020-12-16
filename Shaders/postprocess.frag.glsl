#version 450

uniform sampler2D tex;
in vec2 texCoord;
in vec4 color;
out vec4 FragColor;

#ifdef tonemap_reinhard
vec3 tonemapReinhard(const vec3 color) {
	return color / (color + vec3(1.0));
}
#endif

// https://www.slideshare.net/ozlael/hable-john-uncharted2-hdr-lighting/142
#ifdef tonemap_uncharted2
vec3 uncharted2Tonemap(const vec3 x) {
	const float A = 0.15;
	const float B = 0.50;
	const float C = 0.10;
	const float D = 0.20;
	const float E = 0.02;
	const float F = 0.30;
	return ((x * (A * x + C * B) + D * E) / (x * (A * x + B) + D * F)) - E / F;
}

vec3 tonemapUncharted2(const vec3 color) {
	const float W = 11.2;
	const float exposureBias = 2.0;
	vec3 curr = uncharted2Tonemap(exposureBias * color);
	vec3 whiteScale = 1.0 / uncharted2Tonemap(vec3(W));
	return curr * whiteScale;
}
#endif

// https://knarkowicz.wordpress.com/2016/01/06/aces-filmic-tone-mapping-curve/
#ifdef tonemap_acesfilm
vec3 tonemapAcesFilm(const vec3 x) {
	const float a = 2.51;
	const float b = 0.03;
	const float c = 2.43;
	const float d = 0.59;
	const float e = 0.14;
	return clamp((x * (a * x + b)) / (x * (c * x + d ) + e), 0.0, 1.0);
}
#endif


void main() {
	vec4 texcolor = texture(tex, texCoord) * color;
	texcolor.rgb *= color.a;

	#ifdef chromatic_aberration
	const float chAbb_strength = 0.002;
	float rcolor = texture(tex, vec2(texCoord.x+chAbb_strength, texCoord.y)).r;
	float bcolor = texture(tex, vec2(texCoord.x-chAbb_strength, texCoord.y)).b;
	texcolor.r = rcolor;
	texcolor.b = bcolor;
	#endif

	#ifdef tonemap_reinhard
	texcolor = vec4(tonemapReinhard(texcolor.rgb), texcolor.a);
	#elif tonemap_uncharted2
	texcolor = vec4(tonemapUncharted2(texcolor.rgb), texcolor.a);
	#elif tonemap_acesfilm
	texcolor = vec4(tonemapAcesFilm(texcolor.rgb), texcolor.a);
	#endif

	//https://github.com/armory3d/armory/blob/c7b641cc77cbb7ac77ae90bd209e2d533196b256/Shaders/compositor_pass/compositor_pass.frag.glsl#L114
	#ifdef vignette
	const float vig_strength = 1.5;
	texcolor.rgb *= (1.0 - vig_strength) + vig_strength * pow(15.0 * texCoord.x * texCoord.y * (1.0 - texCoord.x) * (1.0 - texCoord.y), 0.2);
	#endif

	FragColor = texcolor;
}
