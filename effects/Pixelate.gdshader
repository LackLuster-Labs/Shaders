/*
    Pixelate Shader by Lackluster Labs

    MIT License

    Copyright (c) 2024 Lackluster Labs
*/


shader_type spatial;
render_mode unshaded, cull_disabled, depth_draw_always;

uniform sampler2D screen_texture : hint_screen_texture;
uniform int pixel_size : hint_range(1, 64) = 8;

void fragment() {
    vec2 screen_uv = FRAGCOORD.xy / VIEWPORT_SIZE;
    vec2 pixel_uv = floor(screen_uv * float(pixel_size)) / float(pixel_size);
    vec3 color = texture(screen_texture, pixel_uv).rgb;
    ALBEDO = color;
    ALPHA = 1.0;
}
