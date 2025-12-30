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

    // Best fit search
    half3 bestColor = _Palette[0].rgb;
    half bestDistance = distance(bestColor, col);

    [unroll]
    for (int i = 1; i < 8; i++)
    {
        half3 candidate = _Palette[i].rgb;
        half d = distance(candidate, col);
        if (d < bestDistance)
        {
            bestDistance = d;
            bestColor = candidate;
        }
    }

    // sRGB -> Linear
    col = SRGBToLinear(bestColor);

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
