#version 430 core

uniform sampler2D tex;
uniform float angle;
uniform float scale;
//uniform float x_m;
uniform vec2 resolution;
uniform vec2 offset;
//uniform vec2 offset_g;


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
    uv1.x /= 1.86;
    uv1.y /= 0.355;
    uv1 = fract(uv1);
    uv1.x *= 1.86;
    uv1.y *= 0.355;
    return uv1;
}

vec3 addColor(vec2 uv, float x1, float x2, vec3 color_plus) {
    vec3 col = vec3(0,0,0);
    if (uv.x >= x1 && uv.y >= 0.0 && uv.x < x2 && uv.y < 1.0) {
        col = color_plus;
    }
    return col;
}

void main() {
    float x2 = 0.933;
    float y2 = 0.51;
    vec2 uvs1 = uvs-0.5;
    vec2 uv1 = rotate2D(uvs1, angle);
    uv1 = scale2D(uv1)+offset/resolution.y;
    vec2 uv2 = uv1 + vec2(0.457, -0.185);
    vec2 uv3 = uv1 + vec2(0.89, 0.012);
    vec2 uv4 = uv1 + vec2(0.31,0.895);
    vec2 uv5 = uv2 + vec2(0.31,0.895);
    vec2 uv6 = uv3 + vec2(0.31,0.895);
    vec2 uv7 = uv1 + vec2(0.62,0.018);
    vec2 uv8 = uv2 + vec2(0.62,0.018);
    vec2 uv9 = uv3 + vec2(0.62,0.018);
    vec2 uv1_2 = uv1 + vec2(x2,y2);
    vec2 uv2_2 = uv2 + vec2(x2,y2);
    vec2 uv3_2 = uv3 + vec2(x2,y2);
    vec2 uv4_2 = uv4 + vec2(x2,y2);
    vec2 uv5_2 = uv5 + vec2(x2,y2);
    vec2 uv6_2 = uv6 + vec2(x2,y2);
    vec2 uv7_2 = uv7 + vec2(x2,y2);
    vec2 uv8_2 = uv8 + vec2(x2,y2);
    vec2 uv9_2 = uv9 + vec2(x2,y2);
    uv1 = mastb_xy(uv1);
    uv2 = mastb_xy(uv2);
    uv3 = mastb_xy(uv3);
    uv4 = mastb_xy(uv4);
    uv5 = mastb_xy(uv5);
    uv6 = mastb_xy(uv6);
    uv7 = mastb_xy(uv7);
    uv8 = mastb_xy(uv8);
    uv9 = mastb_xy(uv9);
    uv1_2 = mastb_xy(uv1_2);
    uv2_2 = mastb_xy(uv2_2);
    uv3_2 = mastb_xy(uv3_2);
    uv4_2 = mastb_xy(uv4_2);
    uv5_2 = mastb_xy(uv5_2);
    uv6_2 = mastb_xy(uv6_2);
    uv7_2 = mastb_xy(uv7_2);
    uv8_2 = mastb_xy(uv8_2);
    uv9_2 = mastb_xy(uv9_2);
    vec3 col = vec3(0.0, 0.0, 0.0);
    float c_m = 0.7;
    float g_m = 0.7;
    float r_m = 0.8;
    col += addColor(uv1,0.0,0.333,vec3(texture(tex, uv1).r*r_m,0,0));
    col += addColor(uv2,0.333,0.650,vec3(0,texture(tex, uv2).g*g_m,0));
    col += addColor(uv3,0.667,1.0,vec3(0,texture(tex, uv3).g*c_m,texture(tex, uv3).b*c_m));
    col += addColor(uv4,0.0,0.333,vec3(texture(tex, uv4).r*r_m,0,0));
    col += addColor(uv5,0.333,0.650,vec3(0,texture(tex, uv5).g*g_m,0));
    col += addColor(uv6,0.667,1.0,vec3(0,texture(tex, uv6).g*c_m,texture(tex, uv6).b*c_m));
    col += addColor(uv7,0.0,0.333,vec3(texture(tex, uv7).r*r_m,0,0));
    col += addColor(uv8,0.333,0.650,vec3(0,texture(tex, uv8).g*g_m,0));
    col += addColor(uv9,0.667,1.0,vec3(0,texture(tex, uv9).g*c_m,texture(tex, uv9).b*c_m));
    
    col += addColor(uv1_2,0.0,0.333,vec3(texture(tex, uv1_2).r*r_m,0,0));
    col += addColor(uv2_2,0.333,0.650,vec3(0,texture(tex, uv2_2).g*g_m,0));
    col += addColor(uv3_2,0.667,1.0,vec3(0,texture(tex, uv3_2).g*c_m,texture(tex, uv3_2).b*c_m));
    col += addColor(uv4_2,0.0,0.333,vec3(texture(tex, uv4_2).r*r_m,0,0));
    col += addColor(uv5_2,0.333,0.650,vec3(0,texture(tex, uv5_2).g*g_m,0));
    col += addColor(uv6_2,0.667,1.0,vec3(0,texture(tex, uv6_2).g*c_m,texture(tex, uv6_2).b*c_m));
    col += addColor(uv7_2,0.0,0.333,vec3(texture(tex, uv7_2).r*r_m,0,0));
    col += addColor(uv8_2,0.333,0.650,vec3(0,texture(tex, uv8_2).g*g_m,0));
    col += addColor(uv9_2,0.667,1.0,vec3(0,texture(tex, uv9_2).g*c_m,texture(tex, uv9_2).b*c_m));
    f_color = vec4(col, 1.0);
}
