#version 430 core

uniform sampler2D tex;
uniform float angle;
uniform float scale;
uniform vec2 resolution;
uniform vec2 offset;


in vec2 uvs;
out vec4 f_color;

vec2 rotate2D(vec2 uv, float a) {
 float s = sin(a);
 float c = cos(a);
 return mat2(c, -s, s, c) * uv;
}

vec2 scale2D(vec2 uv) {
 return scale*uv;
}

vec2 mastb_xy(vec2 uv1) {
    uv1.x /= 0.8;
    uv1.y /= 0.445;
    uv1 = fract(uv1);
    uv1.x *= 0.8;
    uv1.y *= 0.445;
    return uv1;
}

void main() {
    vec2 uvs1 = uvs-0.5;
    vec2 uv1 = rotate2D(uvs1, angle);
    uv1 = scale2D(uv1)+offset/resolution.y;
    uv1 = mastb_xy(uv1);
    vec3 col = vec3(0.0, 0.0, 0.0);
    if (uv1.x >= 0.0 && uv1.y >= 0.0 && uv1.x < 1.0 && uv1.y < 1.0) {
    col += vec3(texture(tex, uv1).rgb);
    }
    f_color = vec4(col, 1.0);
}
