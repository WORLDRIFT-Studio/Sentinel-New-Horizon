// shader wygenerowany przez chatGPT

shader_type canvas_item;

uniform float strength : hint_range(0.0, 1.0) = 1.0;
uniform float opacity: hint_range(0.0, 1.0) = 0.45;
uniform float radius : hint_range(0.0, 1.0) = 0.85;

void fragment() {
    vec2 center = vec2(0.5, 0.5);
    float dist = distance(UV, center);

    float vignette = smoothstep(radius, radius - 0.5, dist);

    vec4 tex = texture(TEXTURE, UV);
    tex.rgb *= (1.0 - vignette * strength);
	tex.a = opacity;
    COLOR = tex;
}