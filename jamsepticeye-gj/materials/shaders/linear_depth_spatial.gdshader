shader_type spatial;
render_mode unshaded; // Bỏ depth_draw_never để nó có thể ghi đè lên mọi thứ

uniform float mix_factor : hint_range(0.0, 1.0, 0.01) = 0.0;

uniform float max_depth : hint_range(0.0, 50.0, 0.01) = 40.0;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float depth_factor : hint_range(0.0, 256.0, 0.1) = 18.0;

uniform sampler2D DEPTH_TEXTURE : hint_depth_texture;

uniform vec3 tint : source_color = vec3(1.0, 0.5, 0.5);

void fragment() {
    vec3 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;

    float depth = texture(DEPTH_TEXTURE, SCREEN_UV).r;
    float linear_depth = 1.0 / (depth * INV_PROJECTION_MATRIX[2].w + INV_PROJECTION_MATRIX[3].w);
    float depth_normalized = clamp(linear_depth / depth_factor, 0.0, max_depth);
	vec3 depth_color = tint * depth_normalized;

    vec3 final_color = mix(screen_color, depth_color, mix_factor);

    ALBEDO = final_color;

    //ALPHA = mix(1.0, 0.95, mix_factor);
	ALPHA = 0.85;
}
