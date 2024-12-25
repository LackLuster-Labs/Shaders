/*
    MatCap Shader by Lackluster Labs

    MIT License

    Copyright (c) 2024 Lackluster Labs
*/
shader_type spatial;

uniform float scale : hint_range(1.0, 10.0) = 5.0; // Size of Voronoi cells
uniform vec3 color_1 : source_color = vec3(0.2, 0.6, 1.0); // Main crystal color
uniform vec3 color_2 : source_color = vec3(1.0, 1.0, 1.0); // Highlight color
uniform float edge_smoothness : hint_range(0.0, 1.0) = 0.2; // Softness of edges
uniform float animation_speed : hint_range(0.0, 1.0) = 0.1; // Speed of animation

varying vec3 v_world_position;

vec3 hash3(vec3 p) {
    p = fract(p * 0.3183099 + vec3(0.1));
    p *= 17.0;
    return fract(p * p * 0.1);
}

float voronoi3D(vec3 p) {
    vec3 i = floor(p);
    vec3 f = fract(p);

    float min_dist = 1.0;
    for (int z = -1; z <= 1; z++) {
        for (int y = -1; y <= 1; y++) {
            for (int x = -1; x <= 1; x++) {
                vec3 neighbor = vec3(float(x), float(y), float(z));
                vec3 point = hash3(i + neighbor);
                vec3 diff = neighbor + point - f;
                float dist = dot(diff, diff);
                min_dist = min(min_dist, dist);
            }
        }
    }
    return sqrt(min_dist);
}

void vertex() {
    v_world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
    vec3 p = v_world_position * scale;
    p += vec3(TIME * animation_speed);
    float voronoi_value = voronoi3D(p);
    float edge = smoothstep(0.0, edge_smoothness, voronoi_value);
    vec3 color = mix(color_1, color_2, edge);
    ALBEDO = color;
}
