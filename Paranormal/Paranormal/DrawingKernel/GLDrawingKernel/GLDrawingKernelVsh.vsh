attribute vec2 pos;
uniform vec2 scale;
uniform vec2 offset;
varying vec2 texCoord;

void main() {
    gl_Position = vec4(pos.x * scale.x, pos.y * scale.y, 0.0, 1.0);
    texCoord = vec2(pos.x, pos.y);
    gl_Position.x += offset.x;
    gl_Position.y += offset.y;
}
