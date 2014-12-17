// Multiply the two input textures, keeping the second images alpha value
// Used in chamfer

varying vec2 textureCoordinate;
varying vec2 textureCoordinate2;

uniform sampler2D inputImageTexture;
uniform sampler2D inputImageTexture2;

void main() {
    vec4 base = texture2D(inputImageTexture, textureCoordinate);
    vec4 overlayer = texture2D(inputImageTexture2, textureCoordinate2);

    gl_FragColor = overlayer * base;
    gl_FragColor.a = overlayer.a;
}
