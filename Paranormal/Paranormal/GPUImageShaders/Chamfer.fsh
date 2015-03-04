varying vec2 textureCoordinate;

uniform sampler2D inputImageTexture;
uniform float texelWidth;
uniform float texelHeight;
uniform float depth;
uniform float radius; // Pixels
int MAXRAD = int(ceil(radius)); // Pixels
const float normalZero = 0.5;
const float epsilon = 0.001; // less than half 1/255
const vec3 zUpNormal = vec3(0.0, 0.0, 1.0);

vec4 normalToColor(vec3 normal, float alpha) {
    return vec4((normalZero + (0.5 * normal)), alpha);
}

int squaredDistance(int x, int y) {
    return (x * x) + (y * y);
}

// Get nearest zero-alpha pixel in a radius x radius square
// x and y are in percent
// returns vec3(dx, dy, dist)
vec3 closestZero(float x, float y) {
    vec3 nearest = vec3(0, 0, MAXRAD * MAXRAD + 1);
    int dx, dy; // Pixels
    for (dx = -MAXRAD; dx <= MAXRAD; dx++) {
        for (dy = -MAXRAD; dy <= MAXRAD; dy++) {
            int dSquared = squaredDistance(dx, dy); // Pixels
            if (float(dSquared) < nearest.z) {
                float xSample = (x + (texelWidth  * float(dx))) / texelWidth;  // Percent
                float ySample = (y + (texelHeight * float(dy))) / texelHeight; // Percent
                nearest.z = 0.0;
                if (xSample > 0.0 && xSample < 1.0 / texelWidth &&
                    ySample > 0.0 && ySample < 1.0 / texelHeight) {
                    float alphaSample = texture2D(inputImageTexture,
                                                  vec2(xSample, ySample)).a;
                    if (alphaSample < epsilon) {
                        nearest = vec3(dx, dy, dSquared);
                    }
                }
            }
        }
    }
    return vec3(nearest.x, nearest.y, sqrt(nearest.z));
}

void main() {
    vec3 outputNormal;
    vec4 outputColor;
    vec4 baseColor = texture2D(inputImageTexture, textureCoordinate);
    float x = textureCoordinate.x; // Percent
    float y = textureCoordinate.y; // Percent

    vec3 nearest = closestZero(x, y);

    if (nearest.z > float(MAXRAD))
    {
        outputNormal = vec3(0.0, 1.0, 0.0);
    } else {
        vec2 direction = normalize(vec2(nearest.x, nearest.y));
        outputNormal = normalize(vec3(direction.x, direction.y, depth / radius));
    }

    outputColor = normalToColor(outputNormal, baseColor.a);

    gl_FragColor = outputColor;
}
