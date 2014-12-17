varying vec2 textureCoordinate;

uniform sampler2D inputImageTexture;
uniform float texelWidth;
uniform float texelHeight;
uniform float depth;

void main() {
    vec4 outputColor;
    vec4 baseColor = texture2D(inputImageTexture, textureCoordinate);
    float x = textureCoordinate.x;
    float y = textureCoordinate.y;

    float xm1 = texture2D(inputImageTexture, vec2(x - texelWidth, y)).r;
    float xp1 = texture2D(inputImageTexture, vec2(x + texelWidth, y)).r;

    float ym1 = texture2D(inputImageTexture, vec2(x, y - texelHeight)).r;
    float yp1 = texture2D(inputImageTexture, vec2(x, y + texelHeight)).r;

    float dx = -(xp1 - xm1)/(2.0 * texelWidth); // Negative to get normal direction correct
    float dy = (yp1 - ym1)/(2.0 * texelHeight);

    vec3 normal = normalize(vec3(dx, dy, 1.0/depth));

    // Encode normal back into RGB space
    normal = normal * 0.5 + 0.5;
    outputColor = vec4(normal, baseColor.a);

    gl_FragColor = outputColor;
}
