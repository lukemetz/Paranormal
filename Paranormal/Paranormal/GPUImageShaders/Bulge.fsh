varying vec2 textureCoordinate;

uniform sampler2D inputImageTexture;
uniform float texelWidth;
uniform float texelHeight;
uniform float depth;
uniform float radius; // Pixels
uniform float shape;
const float normalZero = 127.0 / 255.0;
const float epsilon = 0.001; // less than half 1/255
const vec3 zUpNormal = vec3(0.0, 0.0, 1.0);
const float PI = 3.14159265359;

float sigma = radius;
float sigmaSquared = radius * radius;
//int MAXRAD = int(ceil(radius)); // Pixels
int MAXRAD = int(ceil(min(0.50 / texelWidth, 0.50 / texelHeight)));
int RTRAD = int(ceil(sqrt(float(MAXRAD))));
float MAXD = float(MAXRAD * MAXRAD) + epsilon; // Pixels squared

vec4 normalToColor(vec3 normal, float alpha) {
    return vec4((normalZero + (0.5 * normal)), alpha);
}

vec3 colorToNormal(vec4 color) {
    return vec3(2.0 * (color.r - normalZero),
                2.0 * (color.g - normalZero),
                2.0 * (color.b - normalZero));
}

float squaredDistance(float x, float y) {
    return (x * x) + (y * y);
}

float weightFunction(float dSquared) {
    return exp(-dSquared / sigmaSquared);
}

float inverseCDF(float p) {
    return -sigma * log(p);
}

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

// Find the direction toward and distance to nearest edge
// returns vec3(dx, dy, dist)
vec3 findEdge(float x, float y) {
    vec2 total = vec2(0.0, 0.0);
    float count = 0.0;
    float dx, dy, dist; // Pixels
    float angle; // Radians
    float xSample, ySample; // Percent
    float alphaWeight, distanceWeight; // Percent
    float dSquared; // Pixels squared
    float minD = MAXD; // Pixels squared

    // Monte Carlo Sampling of the alpha channel
    for (float i = 1.0; i < 999.9; i++) {
        dist = inverseCDF(rand(vec2(x + i, y)));
        angle = rand(vec2(y + i, x)) * 2.0 * PI;
        dx = dist * cos(angle);
        dy = dist * sin(angle);
        dSquared = squaredDistance(dx, dy);
        distanceWeight = weightFunction(dSquared);
        xSample = x + (texelWidth  * dx); // Percent
        ySample = y + (texelHeight * dy); // Percent
        if (xSample > 0.0 && xSample < 1.0 &&
            ySample > 0.0 && ySample < 1.0) {
            alphaWeight = 1.0 - texture2D(inputImageTexture, vec2(xSample, ySample)).a;
        } else {
            alphaWeight = 1.0; // Treat areas outside the image outside the image as transparent
        }
        if (alphaWeight > epsilon) {
            minD = min(minD, dSquared);
            // Negative to get the output normal right
            total += alphaWeight * distanceWeight * normalize(vec2(dx, -dy));
        }
        count += distanceWeight;
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

//    float edgeDist = edge.z;
    float xyMagnitude = clamp(length(edgePoint)* 2.0, 0.0, 1.0);
    vec2 xyDirection = normalize(edgePoint) * xyMagnitude;
    float zValue = sqrt(1.0 - xyMagnitude);
    outputNormal = vec3(xyDirection, zValue);

//    vec2 direction = normalize(edgePoint);

//    if (edgeDist < radius) {
//        float unitDist = clamp((edgeDist / radius), epsilon, 1.0 - epsilon);
//        float normalHeight = tan(PI / 4.0 * (1.0 + (shape * unitDist)));
//        vec3 chamferedNormal = normalize(vec3(direction, normalHeight / depth));
//
//        if (radius - edgeDist < 1.0) { // anti-alias the transition region
//            outputNormal = normalize(mix(zUpNormal, chamferedNormal, radius - edgeDist));
//        } else {
//            outputNormal = chamferedNormal;
//        }
//    } else {
//        outputNormal = zUpNormal;
//    }
    outputColor = normalToColor(outputNormal, baseColor.a);
    gl_FragColor = outputColor;
}
