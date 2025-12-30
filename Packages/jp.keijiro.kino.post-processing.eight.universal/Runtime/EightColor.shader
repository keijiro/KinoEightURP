Shader "Hidden/EightColor"
{
HLSLINCLUDE

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.core/Runtime/Utilities/Blit.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

half _Dithering;
uint _Downsampling;
half _Opacity;
float4 _Palette[8];

SAMPLER(sampler_BlitTexture);

// 2x2 Bayer matrix for dithering
static const half bayer2x2[] = {-0.5, 0.16666666, 0.5, -0.16666666};

half4 Fragment(Varyings input) : SV_Target
{
    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);

    // Downsampling (quantization)
    uint2 pss = input.texcoord * _BlitTexture_TexelSize.zw / _Downsampling;
    float2 uv = pss * _Downsampling * _BlitTexture_TexelSize.xy;

    // Source color sampling
    half4 src = SAMPLE_TEXTURE2D_X(_BlitTexture, sampler_BlitTexture, uv);

    // Linear -> sRGB
    half3 col = LinearToSRGB(src.rgb);

    // Dithering (2x2 bayer)
    half dither = bayer2x2[(pss.y & 1) * 2 + (pss.x & 1)];
    col += dither * _Dithering;

    // Alias for each color
    half3 c1 = _Palette[0].rgb;
    half3 c2 = _Palette[1].rgb;
    half3 c3 = _Palette[2].rgb;
    half3 c4 = _Palette[3].rgb;
    half3 c5 = _Palette[4].rgb;
    half3 c6 = _Palette[5].rgb;
    half3 c7 = _Palette[6].rgb;
    half3 c8 = _Palette[7].rgb;

    // Euclidean distance
    half d1 = distance(c1, col);
    half d2 = distance(c2, col);
    half d3 = distance(c3, col);
    half d4 = distance(c4, col);
    half d5 = distance(c5, col);
    half d6 = distance(c6, col);
    half d7 = distance(c7, col);
    half d8 = distance(c8, col);

    // Best fit search
    half4 rgb_d = half4(c1, d1);
    rgb_d = rgb_d.a < d2 ? rgb_d : half4(c2, d2);
    rgb_d = rgb_d.a < d3 ? rgb_d : half4(c3, d3);
    rgb_d = rgb_d.a < d4 ? rgb_d : half4(c4, d4);
    rgb_d = rgb_d.a < d5 ? rgb_d : half4(c5, d5);
    rgb_d = rgb_d.a < d6 ? rgb_d : half4(c6, d6);
    rgb_d = rgb_d.a < d7 ? rgb_d : half4(c7, d7);
    rgb_d = rgb_d.a < d8 ? rgb_d : half4(c8, d8);

    // sRGB -> Linear
    col = SRGBToLinear(rgb_d.rgb);

    // Blending
    half4 orig = SAMPLE_TEXTURE2D_X(_BlitTexture, sampler_BlitTexture, input.texcoord);
    return lerp(orig, half4(col, src.a), _Opacity);
}

ENDHLSL

    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline"}
        Pass
        {
            ZTest Always ZWrite Off Cull Off
            HLSLPROGRAM
            #pragma vertex Vert
            #pragma fragment Fragment
            ENDHLSL
        }
    }
}
