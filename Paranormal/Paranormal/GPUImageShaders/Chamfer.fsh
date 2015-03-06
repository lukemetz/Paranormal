varying vec2 textureCoordinate;

uniform sampler2D inputImageTexture;
uniform float texelWidth;
uniform float texelHeight;
uniform float depth;
uniform float radius; // Pixels
const float normalZero = 0.5;
const float epsilon = 0.001; // less than half 1/255
const vec3 zUpNormal = vec3(0.0, 0.0, 1.0);

int MAXRAD = int(ceil(radius)); // Pixels squared
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

float squaredDistance(int x, int y, float alpha) {
    float dist = 0.5 - alpha;
    return (squaredDistance(x, y) +
            dist * float(x + y) +
            dist * dist);
}

// Get nearest zero-alpha pixel in a radius x radius square
// x and y are in percent
// returns vec3(dx, dy, dist)
vec2 averageZero(float x, float y) {
    vec2 total = vec2(0.0, 0.0);
    float count = 0.0;
    int dx, dy; // Pixels
    float xSample, ySample; // Percent
    float weight, dSquared;
    for (dx = -MAXRAD; dx <= MAXRAD; dx++) {
        for (dy = -MAXRAD; dy <= MAXRAD; dy++) {
            dSquared = squaredDistance(dx, dy);
            if (dSquared < MAXD) {
                xSample = x + (texelWidth  * float(dx)); // Percent
                ySample = y + (texelHeight * float(dy)); // Percent
                if (xSample > 0.0 && xSample < 1.0 / texelWidth &&
                    ySample > 0.0 && ySample < 1.0 / texelHeight) {
                    weight = 1.0 - texture2D(inputImageTexture, vec2(xSample, ySample)).a;
                } else {
                    weight = 1.0;
                }
                if (weight > epsilon) {
                    total += weight * vec2(dx, -dy); // Negative to get the output normal right
                    count += weight;
                }
            }
        }
    }
    return total / count;
}

void main() {
    vec3 outputNormal;
    vec4 outputColor;
    vec4 baseColor = texture2D(inputImageTexture, textureCoordinate);
    if (texelWidth > 1.0) {
        // The first time this is called, there's an issue where the texel width is not set.
        // Known bug 89581006: Chamfer button takes two clicks to apply
        // For now, we skip this case and return the original.
        gl_FragColor = baseColor;
    } else {
        float x = textureCoordinate.x; // Percent
        float y = textureCoordinate.y; // Percent
        vec2 edgePoint = averageZero(x, y);
        float dist = length(edgePoint);

        if (dist < epsilon) {
            outputNormal = zUpNormal;
        } else {
            vec2 direction = normalize(edgePoint);
            outputNormal = normalize(vec3(direction.x, direction.y, depth / radius));
        }

        outputColor = normalToColor(outputNormal, baseColor.a);

        gl_FragColor = outputColor;
    }
}
