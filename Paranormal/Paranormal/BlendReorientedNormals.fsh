// Heavily inspired by
// http://blog.selfshadow.com/publications/blending-in-detail/

varying vec2 textureCoordinate;

uniform sampler2D inputImageTexture;
uniform sampler2D inputImageTexture2;

vec3 decodeNormal(vec4 color) {
    return vec3(color.x * 2.0 - 1.0, color.y * 2.0 - 1.0, color.z);
}

vec3 encodeNormal(vec3 normal) {
    return vec3(normal.x * 0.5 + 0.5, normal.y * 0.5 + 0.5, normal.z);
}

void main() {
    vec4 outputColor;
    vec4 baseColor = texture2D(inputImageTexture, textureCoordinate);
    vec4 detailColor = texture2D(inputImageTexture2, textureCoordinate);
    vec3 n1 = decodeNormal(baseColor);
    vec3 n2 = decodeNormal(detailColor);

    // FIXME These might need to be transposed
    vec3 basis1 = vec3(n1.z, n1.y, -n1.x); // +90 degree rotation around y axis
    vec3 basis2 = vec3(n1.x, n1.z, -n1.y); // -90 degree rotation around x axis
    vec3 basis3 = vec3(n1.x, n1.y,  n1.z);

    vec3 result = normalize(n2.x * basis1 + n2.y * basis2 + n2.z * basis3);
    outputColor.xyz = encodeNormal(result);
    outputColor.a = baseColor.a;
    gl_FragColor = outputColor;
}
