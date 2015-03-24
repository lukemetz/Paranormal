varying vec2 textureCoordinate;

uniform sampler2D inputImageTexture;
uniform float texelWidth;
uniform float texelHeight;
uniform float depth;
uniform float radius; // Pixels
const float normalZero = 127.0 / 255.0;
const float epsilon = 0.001; // less than half 1/255
const vec3 zUpNormal = vec3(0.0, 0.0, 1.0);

int MAXRAD = int(ceil(radius)); // Pixels
float MAXD = float(MAXRAD * MAXRAD) + epsilon; // Pixels squared

vec4 normalToColor(vec3 normal, float alpha) {
    return vec4((normalZero + (0.5 * normal)), alpha);
}

vec3 colorToNormal(vec4 color) {
    return vec3(2.0 * (color.r - normalZero),
                2.0 * (color.g - normalZero),
                2.0 * (color.b - normalZero));
}

float squaredDistance(int x, int y) {
    return float((x * x) + (y * y));
}

// Find the direction toward and distance to nearest edge
// returns vec3(dx, dy, dist)
vec3 findEdge(float x, float y) {
    vec2 total = vec2(0.0, 0.0);
    float count = 0.0;
    int dx, dy; // Pixels
    float xSample, ySample; // Percent
    float weight;
    float dSquared; // Pixels squared
    float minD = MAXD; // Pixels squared

    for (dx = -MAXRAD; dx <= MAXRAD; dx++) {
        for (dy = -MAXRAD; dy <= MAXRAD; dy++) {
            dSquared = squaredDistance(dx, dy);
            if (dSquared < MAXD) {
                xSample = x + (texelWidth  * float(dx)); // Percent
                ySample = y + (texelHeight * float(dy)); // Percent
                if (xSample > 0.0 && xSample < 1.0 &&
                    ySample > 0.0 && ySample < 1.0) {
                    weight = 1.0 - texture2D(inputImageTexture, vec2(xSample, ySample)).a;
                } else {
                    weight = 1.0;
                }
                if (weight > epsilon) {
                    minD = min(minD, dSquared);
                    total += weight * vec2(dx, -dy); // Negative to get the output normal right
                    count += weight;
                }
            }
        }
    }
    return vec3(total / count, sqrt(minD));
}

void main() {
    vec3 outputNormal;
    vec4 outputColor;
    vec4 baseColor = texture2D(inputImageTexture, textureCoordinate);

    float x = textureCoordinate.x; // Percent
    float y = textureCoordinate.y; // Percent
    vec3 edge = findEdge(x, y);
    vec2 edgePoint = edge.xy;
    float edgeDist = edge.z;

    vec2 direction = normalize(edgePoint);

    if (edgeDist < radius) {
        vec3 chamferedNormal = normalize(vec3(direction, depth / radius));
        if (radius - edgeDist < 1.0) { // anti-alias the transition region
            outputNormal = normalize(mix(zUpNormal, chamferedNormal, radius - edgeDist));
        } else {
            outputNormal = chamferedNormal;
        }
    } else {
        outputNormal = zUpNormal;
    }
    outputColor = normalToColor(outputNormal, baseColor.a);

    gl_FragColor = outputColor;
}
