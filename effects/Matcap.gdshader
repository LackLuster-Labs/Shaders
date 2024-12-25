/*
    MatCap Shader by Lackluster Labs

    MIT License

    Copyright (c) 2024 Lackluster Labs
*/

shader_type spatial;
render_mode unshaded; 

uniform sampler2D matcap : source_color, hint_default_black; // MatCap texture
uniform vec4 color : source_color = vec4(1.0); // Base color
uniform float metalness : hint_range(0.0, 1.0) = 1.0; // Blend strength
uniform float margin : hint_range(0.0, 0.1) = 0.01; // Margin to avoid UV seams
uniform bool is_spatial = false; // Use horizontal wrapping

varying vec3 v_world_normal;
varying vec3 v_world_pos;
varying vec3 v_eye_pos;

const vec3 up = vec3(0.0, 1.0, 0.0);

void vertex() {
    v_world_normal = (MODEL_NORMAL_MATRIX * NORMAL);
    v_world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
    v_eye_pos = (INV_VIEW_MATRIX * vec4(EYE_OFFSET, 1.0)).xyz;
}

void fragment() {
    vec3 normal = normalize(v_world_normal);
    vec3 view_dir = normalize(v_eye_pos - v_world_pos);
    vec3 reflection = reflect(view_dir, normal);

    float vert = dot(reflection, up);
    float hor;
    if (is_spatial) {
        hor = cross(reflection, up).z;
    } else {
        hor = cross(reflection, normal).y;
    }

    vec2 uv = vec2(hor, vert) * (1.0 - margin);
    uv = 0.5 + 0.5 * uv;

    vec3 matcap_color = texture(matcap, uv).rgb;
    vec3 final_color = mix(vec3(1.0), matcap_color, metalness);
    ALBEDO = color.rgb * final_color;
}
