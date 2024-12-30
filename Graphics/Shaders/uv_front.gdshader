shader_type spatial;
render_mode unshaded;
//tentabrobpy
uniform sampler2D image : source_color;
uniform vec2 tiling = vec2(1.0);
uniform vec2 offset = vec2(0.0);

varying vec4 NODE_POSITION_CLIP;

void vertex() {
	 NODE_POSITION_CLIP = (PROJECTION_MATRIX * vec4(NODE_POSITION_VIEW, 1.0));
}

void fragment() {
	vec2 local_uv = (SCREEN_UV * 2.0 - 1.0) * NODE_POSITION_CLIP.w - NODE_POSITION_CLIP.xy;

	// Adjust for aspect ratio and FOV
	local_uv.x *= VIEWPORT_SIZE.x / VIEWPORT_SIZE.y;
	local_uv *= -1.0 / PROJECTION_MATRIX[1][1];

	ALBEDO = texture(image, local_uv * tiling + 0.5 + offset).rgb;
}