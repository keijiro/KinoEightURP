Shader "Hidden/EightColor"
{
HLSLINCLUDE

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.core/Runtime/Utilities/Blit.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

float _Dithering;
float _Downsampling;
float _Opacity;
float4x4 _Palette1;
float4x4 _Palette2;

SAMPLER(sampler_BlitTexture); 

// 2x2 Bayer matrix for dithering
static const float bayer2x2[] = {-0.5, 0.16666666, 0.5, -0.16666666};

half4 Fragment(Varyings input) : SV_Target
{
    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);

    // Downsampling (quantization)
    uint2 pss = input.texcoord * _BlitTexture_TexelSize.zw / _Downsampling;
    float2 uv = pss * _Downsampling * _BlitTexture_TexelSize.xy;

    // Source color sampling
    float4 src = SAMPLE_TEXTURE2D_X(_BlitTexture, sampler_BlitTexture, uv);

    // Linear -> sRGB
    float3 col = LinearToSRGB(src.rgb);

    // Dithering (2x2 bayer)
    float dither = bayer2x2[(pss.y & 1) * 2 + (pss.x & 1)];
    col += dither * _Dithering;

    // Alias for each color
    float3 c1 = _Palette1[0].rgb;
    float3 c2 = _Palette1[1].rgb;
    float3 c3 = _Palette1[2].rgb;
    float3 c4 = _Palette1[3].rgb;
    float3 c5 = _Palette2[0].rgb;
    float3 c6 = _Palette2[1].rgb;
    float3 c7 = _Palette2[2].rgb;
    float3 c8 = _Palette2[3].rgb;

    // Euclidean distance
    float d1 = distance(c1, col);
    float d2 = distance(c2, col);
    float d3 = distance(c3, col);
    float d4 = distance(c4, col);
    float d5 = distance(c5, col);
    float d6 = distance(c6, col);
    float d7 = distance(c7, col);
    float d8 = distance(c8, col);

    // Best fit search
    float4 rgb_d = float4(c1, d1);
    rgb_d = rgb_d.a < d2 ? rgb_d : float4(c2, d2);
    rgb_d = rgb_d.a < d3 ? rgb_d : float4(c3, d3);
    rgb_d = rgb_d.a < d4 ? rgb_d : float4(c4, d4);
    rgb_d = rgb_d.a < d5 ? rgb_d : float4(c5, d5);
    rgb_d = rgb_d.a < d6 ? rgb_d : float4(c6, d6);
    rgb_d = rgb_d.a < d7 ? rgb_d : float4(c7, d7);
    rgb_d = rgb_d.a < d8 ? rgb_d : float4(c8, d8);

    // sRGB -> Linear
    col = SRGBToLinear(rgb_d.rgb);

    // Blending
    float4 orig = SAMPLE_TEXTURE2D_X(_BlitTexture, sampler_BlitTexture, input.texcoord);
    return lerp(orig, float4(col, src.a), _Opacity);
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
