//
// Simple passthrough vertex shader
//
attribute vec3 in_Position;                  // (x,y,z)
attribute vec4 in_Colour;                    // (r,g,b,a) (encoded depth in rg)
attribute vec2 in_TextureCoord;              // (u,v)

uniform float room_height;

varying vec2 v_vTexcoord;

void main()
{	
	float aa = in_Colour.r * 256.0;
	float bb = in_Colour.g * 256.0 * 256.0;
	float cc = (room_height - (aa + bb)) / room_height;
	
    vec4 object_space_pos = vec4( in_Position.x, in_Position.y, cc, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    
    v_vTexcoord = in_TextureCoord;
}