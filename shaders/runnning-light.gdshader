// Shader wygenerowany przez ai 
shader_type canvas_item;

uniform vec4 neon_color : source_color = vec4(0.0, 1.0, 1.0, 1.0);
uniform float speed : hint_range(0.0, 10.0) = 2.0;
uniform float intensity : hint_range(0.0, 10.0) = 3.0; // Siła świecenia (pod Bloom)
uniform float light_width : hint_range(0.0, 1.0) = 0.2;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    
    if (tex_color.a < 0.01) {
        discard;
    }

    vec2 corrected_uv = (UV - 0.5);
    corrected_uv.x *= 1.5; 
    float angle = atan(corrected_uv.y, corrected_uv.x);
    float path = (angle + 3.14159) / 6.28318;
    
    float wave = sin((path - TIME * speed * 0.1) * 6.28318);
    wave = smoothstep(1.0 - light_width, 1.0, (wave + 1.0) / 2.0);
    
    vec3 base_neon = neon_color.rgb * 0.8;
    vec3 running_light = neon_color.rgb * wave * intensity;
    
    COLOR = vec4(base_neon + running_light, tex_color.a);
}