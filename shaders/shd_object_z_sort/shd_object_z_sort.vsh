//
// Simple passthrough vertex shader
//
attribute vec3 in_Position;                  // (x,y,z)
attribute vec4 in_Colour;                    // (r,g,b,a) (encoded data in image_blend, red = depth)
attribute vec2 in_TextureCoord;              // (u,v)

varying vec2 v_vTexcoord;
varying vec4 v_vEncodedData;

void main()
{
    vec4 object_space_pos = vec4( in_Position.x, in_Position.y, in_Colour.r, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    
    v_vEncodedData = in_Colour;
    v_vTexcoord = in_TextureCoord;
}
