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
vec3 closestZero(float x, float y) {
    vec3 nearest = vec3(0, 0, MAXD);
    int dx, dy; // Pixels
    float xSample, ySample; // Percent
    float alpha, dSquared;
    for (dx = -MAXRAD; dx <= MAXRAD; dx++) {
        for (dy = -MAXRAD; dy <= MAXRAD; dy++) {
            dSquared = squaredDistance(dx, dy);
            if (dSquared < MAXD) {
                xSample = x + (texelWidth  * float(dx)); // Percent
                ySample = y + (texelHeight * float(dy)); // Percent
                if (xSample > 0.0 && xSample < 1.0 / texelWidth &&
                    ySample > 0.0 && ySample < 1.0 / texelHeight) {
                    alpha = texture2D(inputImageTexture, vec2(xSample, ySample)).a;
                    if (alpha < 1.0 - epsilon) {
                        dSquared = squaredDistance(dx, dy, alpha);
                    } else {
                        dSquared = MAXD;
                    }
                }
                if (dSquared < nearest.z) {
                    nearest = vec3(dx, dy, dSquared);
                }
            }
        }
    }
    return vec3(nearest.x, -nearest.y, sqrt(nearest.z)); // Negative to get the output normal right
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
        vec3 nearest = closestZero(x, y);
    
        if (nearest.z > float(MAXRAD)) {
            outputNormal = zUpNormal;
//        } else if (nearest.z < epsilon) {
//            outputNormal = vec3(1.0, 0.0, 0.0);
        } else {
            vec2 direction = normalize(vec2(nearest.x, nearest.y));
            outputNormal = normalize(vec3(direction.x, direction.y, depth / radius));
        }

        outputColor = normalToColor(outputNormal, baseColor.a);

        gl_FragColor = outputColor;
    }
}
