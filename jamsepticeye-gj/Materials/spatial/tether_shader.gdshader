shader_type spatial;
render_mode unshaded, cull_disabled, depth_draw_never, blend_add, fog_disabled;

uniform vec4 color : source_color = vec4(0.739, 1.911, 2.616, 0.145);
uniform float glow_strength : hint_range(0.0, 20.0) = 6.0;
uniform float glow_width : hint_range(0.01, 1.0) = 0.335;
uniform float alpha_cutoff : hint_range(0.0, 1.0) = 0.00;
uniform float body_intensity : hint_range(0.0, 1.0) = 0.2;

void fragment() {
    float dist = abs(UV.x - 0.5);
    float fade = exp(-pow(dist / glow_width, 2.0));

    if (fade <= alpha_cutoff) discard;

    vec3 glow_color = color.rgb * fade * glow_strength;

    ALBEDO = color.rgb * body_intensity;
    EMISSION = glow_color;
    ALPHA = fade * color.a;
}
