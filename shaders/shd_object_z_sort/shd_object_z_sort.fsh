//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vEncodedData;

void main()
{
    gl_FragColor = texture2D( gm_BaseTexture, v_vTexcoord );
}
