varying vec2 textureCoordinate;
varying vec2 textureCoordinate2;

uniform sampler2D inputImageTexture;
uniform sampler2D inputImageTexture2;

void main() {
    vec4 base = texture2D(inputImageTexture, textureCoordinate);
    float amount = (base.r + base.g + base.b) * base.a / 3.0;
    vec4 overlayer = texture2D(inputImageTexture2, textureCoordinate2);
    vec4 outputColor = overlayer;
    float factor = 0.1;

    float new = (amount - 0.5) * factor;
    outputColor.x += new;
    outputColor.y += new;
    outputColor.z += new;

    gl_FragColor = outputColor;
}
