uniform sampler2D src;
uniform lowp float qt_Opacity;

varying highp vec2 coord;

void main() {
    lowp vec4 tex = texture2D(src, coord);
    gl_FragColor = tex;
}
