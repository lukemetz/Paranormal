uniform vec2 scale;
uniform vec2 offset;
uniform vec3 color;
uniform float hardness;

varying vec2 texCoord;

void main() {
    float dist = sqrt(texCoord.x * texCoord.x + texCoord.y * texCoord.y);
    // Currently, hardness is linear. A smoothed value will probably work better.
    float alpha = clamp((1.0/hardness)*(1.0-dist), 0.0, 1.0);
    gl_FragColor = vec4(color, alpha);
}
