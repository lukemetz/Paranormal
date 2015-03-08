varying vec2 textureCoordinate;

uniform sampler2D inputImageTexture;

void main() {
    vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
    vec4 outputColor;
    outputColor.x = 0.498; // 127 / 255
    outputColor.y = 0.498; // 127 / 255
    outputColor.z = 1.0;
    outputColor.a = textureColor.a;

    gl_FragColor = outputColor;
}
