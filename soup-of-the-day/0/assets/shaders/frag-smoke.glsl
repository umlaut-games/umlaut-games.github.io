precision mediump float;
uniform vec2      dimensions;
uniform float     time;
uniform float     alpha;
uniform vec2      speed;
uniform float     shift;

float rand(vec2 n) {
    return fract(cos(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float noise(vec2 n) {
    const vec2 d = vec2(0.0, 1.0);
    vec2 b = floor(n), f = smoothstep(vec2(0.0), vec2(1.0), fract(n));
    return mix(mix(rand(b), rand(b + d.yx), f.x), mix(rand(b + d.xy), rand(b + d.yy), f.x), f.y);
}

float fbm(vec2 n) {
    float total = 0.0, amplitude = 2.0;
    for (int i = 0; i < 4; i++) {
        total += noise(n) * amplitude;
        n += n;
        amplitude *= 0.5;
    }
    return total;
}

void main() {
    const vec3 c1 = vec3(150.0/255.0, 210.0/255.0, 240.0/255.0);
    const vec3 c2 = vec3(10.0/255.0, 10.0/255.0, 12.4/255.0);
    const vec3 c3 = vec3(0.0, 0.0, 0.0);
    const vec3 c4 = vec3(100.0/255.0, 100.0/255.0, 110.4/255.0);
    const vec3 c5 = vec3(0.1);
    const vec3 c6 = vec3(0.9);

    vec2 resolution = dimensions;
    vec2 p = gl_FragCoord.xy / resolution.xx;
    vec4 BackgroundColor = vec4(0.922, 0.940, 0.343, 1.0);

    float q = fbm(p - time * 0.1);
    vec2 r = vec2(fbm(p + q + time * speed.x - p.x - p.y), fbm(p + q - time * speed.y));
    vec3 c = mix(c1, c2, fbm(p + r)) + mix(c3, c4, r.x) - mix(c5, c6, r.y);
    float grad = (gl_FragCoord.y + 300.0) / resolution.y;

    vec3 endColor = (c - (-0.0)) * cos(shift * gl_FragCoord.y / resolution.y) + 0.0;

    float endAlpha = 0.0;
    gl_FragColor = vec4(endColor, endAlpha);
    gl_FragColor.xyz *= 0.4-grad;

}