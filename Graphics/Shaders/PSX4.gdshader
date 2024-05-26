shader_type spatial;
render_mode vertex_lighting, skip_vertex_transform, 
             diffuse_lambert, shadows_disabled;

//uniform vec4 modulate: hint_color = vec4(1,1,1,1);
uniform sampler2D image_texture: hint_normal;
uniform vec2 uv_scrolling_velocity = vec2(0.0);

uniform float vertex_snapping_offset = 0.5;


varying float vertex_distance;

void vertex() {
    UV += uv_scrolling_velocity * TIME;

    VERTEX = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;

    float z_origin = VERTEX.z;
    float snap_i = (1.0 - vertex_snapping_offset) * min(VIEWPORT_SIZE.x, VIEWPORT_SIZE.y) / 2.0;

    float projection_w = (PROJECTION_MATRIX * vec4(VERTEX, 1.0)).w;
    VERTEX = round(VERTEX / projection_w * snap_i) / snap_i * projection_w;
    VERTEX = VERTEX;
    
    NORMAL = (MODELVIEW_MATRIX * vec4(NORMAL, 0.0)).xyz;

    vertex_distance = length((VIEW_MATRIX * vec4(VERTEX, 1.0)));

    UV *= VERTEX.z;
}

float get_dither_brightness(vec3 given_color, vec4 fragcoord) {

    int x = int(fragcoord.x) % 4;
    int y = int(fragcoord.y) % 4;
    const vec3 luminance = vec3(0.2126, 0.7152, 0.0722);
    float calculated_brightness = (luminance.r * given_color.r) + (luminance.g * given_color.g) + (luminance.b * given_color.b);


    float thresholdMatrix[16] = float[16] (
        1.0 / 17.0,  9.0 / 17.0,  3.0 / 17.0, 11.0 / 17.0,
        13.0 / 17.0,  5.0 / 17.0, 15.0 / 17.0,  7.0 / 17.0,
        4.0 / 17.0, 12.0 / 17.0,  2.0 / 17.0, 10.0 / 17.0,
        16.0 / 17.0,  8.0 / 17.0, 14.0 / 17.0,  6.0 / 17.0
    );

    float dithering = thresholdMatrix[x * 4 + y];
    
    if ((calculated_brightness - 0.2 < dithering) && (vertex_distance < 60.)) {
        return ((dithering - 0.5) * 0.25) + 1.0;
    } else {
        return 1.;
    }
}

void fragment() {
    vec2 uv = UV / VERTEX.z;

//    vec3 texture_rgb = (texture(image_texture, uv).rgb * COLOR.rgb) * modulate.rgb;
//    vec4 texture_rgba = vec4(texture_rgb.r, texture_rgb.g, texture_rgb.b, 1.0);

//    texture_rgba = texture_rgba * get_dither_brightness(texture_rgba.rgb, FRAGCOORD);
//    ALBEDO = texture_rgba.rgb;
//    ALPHA = texture(image_texture, uv).a * modulate.a;
//    ALPHA_SCISSOR = 0.1;
}