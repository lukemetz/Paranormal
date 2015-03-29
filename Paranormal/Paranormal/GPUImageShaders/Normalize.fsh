varying vec2 textureCoordinate;
uniform sampler2D inputImageTexture;
const float normalZero = 127.0/255.0;

vec3 colorToNormal(vec4 color) {
    return vec3(2.0 * (color.r - normalZero),
                2.0 * (color.g - normalZero),
                2.0 * (color.b - normalZero));
}

vec4 normalToColor(vec3 normal, float alpha) {
    return vec4((normalZero + (0.5 * normal)), alpha);
}

void main() {
    vec4 baseColor = texture2D(inputImageTexture, textureCoordinate);
    vec3 vector = colorToNormal(baseColor);
    vec3 normalizedVector = normalize(vector);
    gl_FragColor = baseColor;
}

