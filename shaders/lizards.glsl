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
    uv1.x /= 1.0;
    uv1.y /= 0.558;
    uv1 = fract(uv1);
    uv1.x *= 1.0;
    uv1.y *= 0.558;
    return uv1;
}

void main() {
    vec2 uvs1 = uvs-0.5;
    vec2 uv1 = rotate2D(uvs1, angle);
    uv1 = scale2D(uv1)+offset/resolution.y;
    vec2 uv2 = uv1 + vec2(0.442, -0.202);
    vec2 uv3 = uv1 + vec2(-0.105, -0.01);
    uv1 = mastb_xy(uv1);
    uv2 = mastb_xy(uv2);
    uv3 = mastb_xy(uv3);
    vec3 col = vec3(0.0, 0.0, 0.0);
    if (uv1.x >= 0.0 && uv1.y >= 0.0 && uv1.x < 0.333 && uv1.y < 1.0) {
    col += vec3(texture(tex, uv1).r,0,0);
    }
    if (uv2.x >= 0.333 && uv2.y >= 0.0 && uv2.x < 0.666 && uv2.y < 1.0) {
    col += vec3(0,texture(tex, uv2).g,0);
    }
    if (uv3.x >= 0.666 && uv3.y >= 0.0 && uv3.x < 1.0 && uv3.y < 1.0) {
    col += vec3(0,0,texture(tex, uv3).b);
    }
    f_color = vec4(col, 1.0);
}
