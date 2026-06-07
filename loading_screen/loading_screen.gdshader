shader_type canvas_item;

uniform float blur_amount : hint_range(0.0, 10.0) = 1.5;

void fragment() {
    vec4 color = vec4(0.0);
    float total = 0.0;

    for (float x = -4.0; x <= 4.0; x++) {
        for (float y = -4.0; y <= 4.0; y++) {
            vec2 offset = vec2(x, y) * TEXTURE_PIXEL_SIZE * blur_amount;
            color += texture(TEXTURE, UV + offset);
            total += 1.0;
        }
    }

    COLOR = color / total;
}