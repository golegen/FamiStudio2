attribute vec2  inPosition;
attribute float inDepth;

uniform vec4 screenScaleBias;

void main()
{
    gl_Position = vec4(inPosition.xy * screenScaleBias.xy + screenScaleBias.zw, inDepth, 1);
}
