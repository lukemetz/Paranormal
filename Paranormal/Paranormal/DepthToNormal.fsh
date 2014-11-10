varying vec2 textureCoordinate;

uniform sampler2D inputImageTexture;
uniform float texelWidth;
uniform float texelHeight;

void main() {
    vec4 outputColor;

    float x = textureCoordinate.x;
    float y = textureCoordinate.y;

    vec4 xy = texture2D(inputImageTexture, textureCoordinate);
    float xm1 = texture2D(inputImageTexture, vec2(x - texelWidth, y)).r;
    float xp1 = texture2D(inputImageTexture, vec2(x + texelWidth, y)).r;

    float ym1 = texture2D(inputImageTexture, vec2(x, y - texelHeight)).r;
    float yp1 = texture2D(inputImageTexture, vec2(x, y + texelHeight)).r;

    float dx = (xp1 - xm1)/(2.0 * texelWidth);
    float dy = (yp1 - ym1)/(2.0 * texelHeight);

    vec3 trial = vec3(dx, dy, 5.0);
    trial = normalize(trial);
    trial.x += 0.5;
    trial.y += 0.5;
    outputColor = vec4(trial, 1.0);

    gl_FragColor = outputColor;
}