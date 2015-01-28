varying vec2 textureCoordinate;

uniform sampler2D inputImageTexture;

void main() {
    vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
    vec4 outputColor;
    outputColor.x = 0.5;
    outputColor.y = 0.5;
    outputColor.z = 1.0;
    outputColor.a = textureColor.a;

    gl_FragColor = outputColor;
}
