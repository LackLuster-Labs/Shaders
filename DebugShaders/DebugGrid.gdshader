/*
    DebugGrid Shader by Lackluster Labs

    MIT License

    Copyright (c) 2024 Lackluster Labs
*/


shader_type spatial;

uniform float subdivisions : hint_range(1, 1024, 1.0) = 32;
uniform float grid_width : hint_range(0.0, 1.0, 0.01) = 0.02;
uniform vec3 grid_color : source_color = vec3(0.5, 0.5, 0.5);
uniform vec3 background_color : source_color = vec3(0.1, 0.1, 0.1);

uniform vec3 emissive_color : source_color = vec3(1.0, 1.0, 1.0);
uniform float emissive_intensity : hint_range(0.0, 10.0) = 1.0;

uniform vec3 secondary_grid_color : source_color = vec3(0.3, 0.3, 0.3);
uniform float secondary_grid_width : hint_range(0.0, 1.0, 0.01) = 0.01;

float grid(vec2 uv, float lineWidth) {
    vec2 gridUV = abs(fract(uv) - 0.5) / lineWidth;
    return step(0.5, min(gridUV.x, gridUV.y));
}

float secondary_intersecting_grid(vec2 uv, float lineWidth) {
    vec2 gridUV = fract(uv * vec2(10.0)); 
    vec2 intersect = step(0.5, abs(fract(gridUV) - 0.5) / lineWidth);
    return min(intersect.x, intersect.y);
}

void fragment() {
    vec2 uv = UV * subdivisions;
    vec3 color = background_color;
    float primaryGrid = 1.0 - grid(uv, grid_width);
    color = mix(color, grid_color, primaryGrid);
    float secondaryGrid = secondary_intersecting_grid(uv, secondary_grid_width);
    color = mix(color, secondary_grid_color, secondaryGrid);
    EMISSION = emissive_color * (primaryGrid + secondaryGrid) * emissive_intensity;
    ALBEDO = color;
}