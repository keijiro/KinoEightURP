Shader "Hidden/EightColor"
{
    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline"}
        ZTest Always ZWrite Off Cull Off
        Pass
        {
            name "EightColor"
            HLSLPROGRAM
            #pragma vertex Vert
            #pragma fragment Fragment
            #define PALETTE_ENTRIES 8
            #include "EightColor.hlsl"
            ENDHLSL
        }
        Pass
        {
            name "SixteenColor"
            HLSLPROGRAM
            #pragma vertex Vert
            #pragma fragment Fragment
            #define PALETTE_ENTRIES 16
            #include "EightColor.hlsl"
            ENDHLSL
        }
    }
}
