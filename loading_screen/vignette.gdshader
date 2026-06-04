shader_type canvas_item;

uniform float intensity : hint_range(0.0, 1.0) = 0.1;
uniform float smoothness : hint_range(0.0, 1.0) = 0.25;

void fragment() {
    vec2 uv = UV - 0.5;
    float vignette = smoothstep(0.8, 0.8 - smoothness, length(uv) * (1.0 + intensity));
    COLOR = vec4(0.0, 0.0, 0.0, 1.0 - vignette);
}