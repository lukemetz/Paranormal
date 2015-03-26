uniform vec2 scale;
uniform vec2 offset;
uniform vec3 color;
uniform float hardness;
const float epsilon = 0.001; // less than half 1/255
const float PI = 3.14159265359;
float alpha;

varying vec2 texCoord;

void main() {
    float dist = sqrt(texCoord.x * texCoord.x + texCoord.y * texCoord.y);
    if (hardness > (1.0 - epsilon)) {
        alpha = (dist < 1.0) ? 1.0 : 0.0;
    } else {
        float distFromEdge = 1.0 - dist;
        float linearAlpha = clamp(1.0/(1.0 - hardness) * (1.0 - dist), 0.0, 1.0);
        alpha = smoothstep(0.0, 1.0, linearAlpha);
    }
    gl_FragColor = vec4(color, alpha);
}
