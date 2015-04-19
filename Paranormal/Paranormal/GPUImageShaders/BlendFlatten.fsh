const float epsilon = 0.001; // less than half 1/255
const float normalZero = 127.0/255.0;

vec3 colorToNormal(vec4 color) {
    return vec3(2.0 * (color.r - normalZero),
                2.0 * (color.g - normalZero),
                2.0 * (color.b - normalZero));
}

vec4 normalToColor(vec3 normal, float alpha) {
    return vec4((normalZero + (0.5 * normal)), alpha);
}

varying vec2 textureCoordinate;

uniform sampler2D inputImageTexture;
uniform sampler2D inputImageTexture2;
uniform float opacity;

void main() {
    vec4 baseColor = texture2D(inputImageTexture, textureCoordinate);
    vec4 flattenColor = texture2D(inputImageTexture2, textureCoordinate);

    float factor = 1.0 - 0.9 * (flattenColor.a * opacity);
    vec3 norm = colorToNormal(baseColor);

    // For numerical stability
    norm.x += epsilon;
    norm = normalize(norm);

    vec4 outputColor;
    if (norm.z < epsilon) {
        outputColor = baseColor;
    } else {
        float width = length(norm.xy) / norm.z;
        float flattenedWidth = width * factor;

        vec2 direction = normalize(norm.xy);
        vec3 transformedNormal = normalize(vec3(flattenedWidth * direction, 1.0));

        outputColor = normalToColor(transformedNormal, baseColor.a);
    }
    gl_FragColor = outputColor;
}
