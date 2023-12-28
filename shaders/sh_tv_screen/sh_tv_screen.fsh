//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 u_resolution;

const float aberration = .5;
const vec2 curvature = vec2(6.0);
const vec4 black = vec4(0.0, 0.0, 0.0, 1.0);

vec2 curveRemapUV(vec2 uv)
{
    uv = uv * 2.0 - 1.0;
    vec2 offset = abs(uv.yx) / vec2(curvature.x, curvature.y);
    uv = uv + uv * offset * offset;
    uv = uv * 0.5 + 0.5;
    return uv;
}

vec4 vignetteIntensity(vec2 uv, vec2 resolution, float opacity)
{
    float intensity = uv.x * uv.y * (1.0 - uv.x) * (1.0 - uv.y);
    return vec4(vec3(clamp(pow((resolution.x / 4.0) * intensity, opacity), 0.0, 1.0)), 1.0);
}

void main() {
    vec2 uv = curveRemapUV(v_vTexcoord);
	vec2 pixel_size = vec2( 1.0 / u_resolution.x, 1.0 / u_resolution.y );

    vec2 strength =  (uv - 0.5) * 2.0 * (1.0 / u_resolution) * aberration;
    //vec2 strength =  vec2(pixel_size.x * aberration, 0.0);

    vec4 base_col   = texture2D( gm_BaseTexture, uv );
	base_col.rgb	= texture2D( gm_BaseTexture, uv + strength ).rgb * vec3(1.0, 0.0, 0.5) +
					  texture2D( gm_BaseTexture, uv - strength ).rgb * vec3(0.0, 1.0, 0.5);

    if (uv.x < 0.0 || uv.y < 0.0 || uv.x > 1.0 || uv.y > 1.0)
    {
        base_col = black;
    }
	
	//base_col *= mod(ceil(u_resolution.y * uv.y), 2.0) >= 1.0 ? 0.95 : 1.0;

    base_col *= vignetteIntensity(uv, u_resolution * 22.0, 1.5);

    gl_FragColor = base_col;
}