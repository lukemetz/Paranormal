varying vec2 textureCoordinate;

uniform sampler2D inputImageTexture;

void main() {
    vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
    float alpha = textureColor.a;
    gl_FragColor = vec4(alpha);
}
