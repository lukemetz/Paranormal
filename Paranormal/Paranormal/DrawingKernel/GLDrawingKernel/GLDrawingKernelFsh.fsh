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
        dist = clamp(dist, 0.0, 1.0);
        // smooth edges with sin
        float smoothDist = (1.0 + sin(PI * (dist - 0.5))) / 2.0;
        // Map hardnesses (0.0, 1.0) to powers (0.5, inf)
        float power = 1.0 / (2.0 - 2.0 * hardness); // max value of 2/epsilon
        // alpha is a high power function of dist for high hardnesses
        alpha = 1.0 - pow(smoothDist, power);
    }
    gl_FragColor = vec4(color, alpha);
}
