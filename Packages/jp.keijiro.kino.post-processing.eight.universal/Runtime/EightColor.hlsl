#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.core/Runtime/Utilities/Blit.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

half _Dithering;
uint _Downsampling;
half _Opacity;
float4 _PaletteLab[PALETTE_ENTRIES];
float4 _PaletteRGB[PALETTE_ENTRIES];

SAMPLER(sampler_BlitTexture);

// 2x2 Bayer matrix for dithering
static const half bayer2x2[] = {-0.5, 0, 0.25, -0.25};

// Distance without sqrt
half ec_sqdist(half3 a, half3 b)
{
    return dot(a - b, a - b);
}

// Linear sRGB to OKLab
half3 ec_LinearToOKLab(half3 c)
{
    half3x3 rgb2lms = half3x3(0.4122214708,  0.5363325363,  0.0514459929,
                              0.2119034982,  0.6806995451,  0.1073969566,
                              0.0883024619,  0.2817188376,  0.6299787005);
    half3x3 lms2lab = half3x3(0.2104542553,  0.7936177850, -0.0040720468,
                              1.9779984951, -2.4285922050,  0.4505937099,
                              0.0259040371,  0.7827717662, -0.8086757660);
    return mul(lms2lab, pow(mul(rgb2lms, c), 1.0 / 3));
}

half4 Fragment(Varyings input) : SV_Target
{
    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);

    // Downsampling (quantization)
    uint2 pss = input.texcoord * _BlitTexture_TexelSize.zw / _Downsampling;
    float2 uv = (pss + 0.5) * _Downsampling * _BlitTexture_TexelSize.xy;

    // Dithering (2x2 bayer)
    half dither = bayer2x2[(pss.y & 1) * 2 + (pss.x & 1)] * _Dithering;

    // Source color sampling in Linear sRGB / Gamma sRGB / OKLab
    half4 src = SAMPLE_TEXTURE2D_X(_BlitTexture, sampler_BlitTexture, uv);
    half3 src_linear = saturate(src.rgb + dither);
    half3 src_gamma = LinearToSRGB(src_linear);
    half3 src_lab = ec_LinearToOKLab(src_linear);

    // Best fit search
    half3 best_gamma = _PaletteRGB[0].rgb;
    half best_dist = ec_sqdist(src_lab, _PaletteLab[0].rgb);

    [unroll]
    for (int i = 1; i < PALETTE_ENTRIES; i++)
    {
        half dist = ec_sqdist(src_lab, _PaletteLab[i].rgb);
        if (dist < best_dist)
        {
            best_gamma = _PaletteRGB[i].rgb;
            best_dist = dist;
        }
    }

    // Blending
    half4 orig = SAMPLE_TEXTURE2D_X(_BlitTexture, sampler_BlitTexture, input.texcoord);
    return lerp(orig, half4(SRGBToLinear(best_gamma), src.a), _Opacity);
}
