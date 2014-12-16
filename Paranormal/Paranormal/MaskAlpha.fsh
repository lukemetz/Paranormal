varying vec2 textureCoordinate;

uniform sampler2D inputImageTexture;

void main() {
    vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
    vec4 outputColor;
    outputColor.x = textureColor.a;
    outputColor.y = textureColor.a;
    outputColor.z = textureColor.a;
    outputColor.a = textureColor.a;

    gl_FragColor = outputColor;
}