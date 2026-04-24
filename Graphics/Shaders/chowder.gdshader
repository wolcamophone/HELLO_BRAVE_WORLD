//   https://godotshaders.com/author/gmpf/

shader_type spatial;
render_mode unshaded;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo;
uniform float scale = 1.0;

void fragment() {
    vec2 screen_uv = SCREEN_UV * scale;
    vec4 tex = texture(texture_albedo, screen_uv);

	vec4 albedo_tex = texture(texture_albedo, screen_uv);
	// Albedo Texture Force sRGB: Enabled
	albedo_tex.rgb = mix(
			pow((albedo_tex.rgb + vec3(0.055)) * (1.0 / (1.0 + 0.055)), vec3(2.4)),
			albedo_tex.rgb.rgb * (1.0 / 12.92),
			lessThan(albedo_tex.rgb, vec3(0.04045)));

    ALBEDO = albedo.rgb * albedo_tex.rgb * tex.rgb;
	ALPHA = albedo_tex.a;
}
