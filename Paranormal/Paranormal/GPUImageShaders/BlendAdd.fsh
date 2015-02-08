varying vec2 textureCoordinate;

uniform sampler2D inputImageTexture;
uniform sampler2D inputImageTexture2;

void main() {
    vec4 outputColor;
    vec4 baseColor = texture2D(inputImageTexture, textureCoordinate);
    vec4 overlayColor = texture2D(inputImageTexture2, textureCoordinate);
    vec4 solidOverlayColor = overlayColor;
    solidOverlayColor.a = 1.0;

    outputColor = mix(baseColor, overlayColor, overlayColor.a);

    gl_FragColor = outputColor;
}
