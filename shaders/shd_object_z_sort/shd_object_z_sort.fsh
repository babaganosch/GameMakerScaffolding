//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;

void main()
{
	vec4 sprite_color = texture2D( gm_BaseTexture, v_vTexcoord );
	if (sprite_color.a < 1.0) { discard; }
    gl_FragColor = sprite_color;
}
