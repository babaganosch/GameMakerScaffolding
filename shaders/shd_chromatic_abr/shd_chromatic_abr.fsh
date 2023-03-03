//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    vec4 base_col;
    base_col = texture2D( gm_BaseTexture, v_vTexcoord);
    base_col.rgb = texture2D( gm_BaseTexture, v_vTexcoord - vec2(0.0007, 0.0)).rgb * vec3(1.0, 0.0, 0.5)	+
    			   texture2D( gm_BaseTexture, v_vTexcoord + vec2(0.0007, 0.0)).rgb * vec3(0.0, 1.0, 0.5); 
    gl_FragColor = base_col;
}
