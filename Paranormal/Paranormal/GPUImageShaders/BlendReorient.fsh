varying vec2 textureCoordinate;

uniform sampler2D inputImageTexture;
uniform sampler2D inputImageTexture2;
const float normalZero = 127.0 / 255.0;
uniform float opacity;

vec3 colorToNormal(vec4 color) {
    return vec3(2.0 * (color.r - normalZero),
                2.0 * (color.g - normalZero),
                2.0 * (color.b - normalZero));
}

vec4 normalToColor(vec3 normal, float alpha) {
    return vec4((normalZero + (0.5 * normal)), alpha);
}

void main() {
    vec4 outputColor;
    vec4 baseColor = texture2D(inputImageTexture, textureCoordinate);
    vec4 detailColor = texture2D(inputImageTexture2, textureCoordinate);
    vec3 n1 = colorToNormal(baseColor);
    vec3 n2 = colorToNormal(detailColor);

    float hx1 = -(n1.x / n1.z);
    float hy1 = -(n1.y / n1.z);
    float hx2 = -(n2.x / n2.z);
    float hy2 = -(n2.y / n2.z);

    // Add the local heightmaps together, adjusting for strength
    float strength = opacity * detailColor.a;
    float hx = hx1 + strength * hx2;
    float hy = hy1 + strength * hy2;
    // Create the resultant plane's normal vector
    vec3 xVector = vec3(1.0, 0.0, hx);
    vec3 yVector = vec3(0.0, 1.0, hy);
    vec3 result = normalize(cross(xVector, yVector));

    outputColor = normalToColor(result, baseColor.a);
    gl_FragColor = outputColor;
}
