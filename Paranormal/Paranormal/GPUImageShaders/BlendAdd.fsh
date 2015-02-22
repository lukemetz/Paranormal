varying vec2 textureCoordinate;

uniform sampler2D inputImageTexture;
uniform sampler2D inputImageTexture2;
uniform float opacity;

void main() {
    vec4 outputColor;
    vec4 baseColor = texture2D(inputImageTexture, textureCoordinate);
    vec4 overlayColor = texture2D(inputImageTexture2, textureCoordinate);

    outputColor = mix(baseColor, overlayColor, overlayColor.a*opacity);

    gl_FragColor = outputColor;
}
