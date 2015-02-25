const float normalZero = 0.5;
const float epsilon = 0.001; // less than half 1/255
const vec3 zUpNormal = vec3(0.0, 0.0, 1.0);

float angle(vec3 a, vec3 b) {
    return acos(dot(a, b) / (length(a) * length (b)));
}

vec3 colorToNormal(vec4 color) {
    return vec3(2.0 * (color.r - normalZero),
                2.0 * (color.g - normalZero),
                2.0 * (color.b - normalZero));
}

vec4 normalToColor(vec3 normal, float alpha) {
    return vec4((normalZero + (0.5 * normal)), alpha);
}

vec3 slerp(vec3 fromVector, vec3 toVector, float mixRatio) {
    // Gemetric formula from http://en.wikipedia.org/wiki/Slerp

    float theta = angle(fromVector, toVector);
    float sinTheta = sin(theta);


    float toPortion   = sin(theta * mixRatio) / sinTheta;
    float fromPortion = sin(theta * (1.0 - mixRatio)) / sinTheta;

    vec3 slerpVector = normalize(fromVector * fromPortion + toVector * toPortion);

    // In situations where the vectors are nearly opposites, we sometimes get a
    // negative z-value. In these cases the conjugate is just as valid, so we return
    // that instead.
    if (slerpVector[2] < 0.0) {
        slerpVector[2] = -slerpVector[2];
    }
    return slerpVector;
}

varying vec2 textureCoordinate;

uniform sampler2D inputImageTexture;
uniform sampler2D inputImageTexture2;
uniform float opacity;

void main() {
    vec4 baseColor = texture2D(inputImageTexture, textureCoordinate);
    vec4 flattenRaise = texture2D(inputImageTexture2, textureCoordinate);

    float factor = flattenRaise.a * opacity;

    vec3 norm = colorToNormal(baseColor);

    vec3 target = vec3(0.0, 0.0, 1.0);
    vec3 transformedNormal = slerp(norm, target, factor);

    vec4 outputColor;
    outputColor = normalToColor(transformedNormal, baseColor.a);
    gl_FragColor = outputColor;
}
