// Heavily inspired by
// http://blog.selfshadow.com/publications/blending-in-detail/

varying vec2 textureCoordinate;

uniform sampler2D inputImageTexture;
uniform sampler2D inputImageTexture2;
uniform float opacity;

vec3 decodeNormal(vec4 color) {
    return color.xyz * 2.0 - 1.0;
}

vec3 encodeNormal(vec3 normal) {
    return normal * 0.5 + 0.5;
}

void main() {
    vec4 outputColor;
    vec4 baseColor = texture2D(inputImageTexture, textureCoordinate);
    vec4 detailColor = texture2D(inputImageTexture2, textureCoordinate);
    vec3 n1 = decodeNormal(baseColor);
    vec3 n2 = decodeNormal(detailColor);

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

    outputColor.xyz = encodeNormal(result);
    outputColor.a = 1.0;
    gl_FragColor = outputColor;
}
