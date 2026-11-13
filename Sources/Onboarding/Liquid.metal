#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

namespace liquid {

float hash(float2 p) {
    p = fract(p * float2(443.897, 441.423));
    p += dot(p, p.yx + 19.19);
    return fract((p.x + p.y) * p.x);
}

float noise(float2 p) {
    float2 i = floor(p);
    float2 f = fract(p);
    float2 u = f * f * (3.0 - 2.0 * f);
    float a = hash(i);
    float b = hash(i + float2(1.0, 0.0));
    float c = hash(i + float2(0.0, 1.0));
    float d = hash(i + float2(1.0, 1.0));
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float fbm(float2 p) {
    float v = 0.0;
    float a = 0.5;
    float2x2 rot = float2x2(0.8, -0.6, 0.6, 0.8);
    for (int i = 0; i < 5; i++) {
        v += a * noise(p);
        p = rot * p * 2.02;
        a *= 0.5;
    }
    return v;
}

}

[[ stitchable ]] half4 liquidBackground(
    float2 position,
    half4 currentColor,
    float2 size,
    float time,
    half4 accent,
    half4 base
) {
    float2 uv = position / max(size, float2(1.0));
    float aspect = size.x / max(size.y, 1.0);
    float2 p = float2(uv.x * aspect, uv.y) * 2.4;

    float t = time * 0.18;

    float2 q = float2(
        liquid::fbm(p + float2(0.0, t)),
        liquid::fbm(p + float2(5.2, 1.3 - t))
    );

    float2 r = float2(
        liquid::fbm(p + 4.0 * q + float2(1.7, 9.2 + t * 0.7)),
        liquid::fbm(p + 4.0 * q + float2(8.3, 2.8 - t * 0.6))
    );

    float n = liquid::fbm(p + 4.0 * r);

    float topMask = pow(saturate(1.0 - uv.y * 1.05), 1.4);
    float intensity = smoothstep(0.18, 0.82, n) * topMask;

    half4 result = mix(base, accent, half(intensity));

    float vignette = smoothstep(1.4, 0.4, distance(uv, float2(0.5, 0.4)));
    result.rgb *= half(0.88 + 0.12 * vignette);

    return result;
}
