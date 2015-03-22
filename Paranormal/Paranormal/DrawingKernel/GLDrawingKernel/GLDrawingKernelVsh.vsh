attribute vec2 vertex_position;
uniform vec2 scale;
uniform vec2 offset;
varying vec2 texCoord;

void main() {
    gl_Position = vec4(vertex_position.x * scale.x, vertex_position.y * scale.y, 0.0, 1.0);
    texCoord = vec2(vertex_position.x, vertex_position.y);
    gl_Position.x += offset.x;
    gl_Position.y += offset.y;
}
