Shader "Custom/PredictedFallPoint"
{
    Properties{
        _OutOfRangeColor ("”ÍˆÍŠO‚ÌF",Color) = (1,1,1,1)
        _WithInColor ("”ÍˆÍ“à‚ÌF", Color) = (1,1,1,1)
    }
    SubShader{
        Tags { "RenderType" = "Opaque" }
        LOD 300

        CGPROGRAM
        #pragma surface surf Standard
        #pragma target 3.0

        struct Input{
            float3 worldPos;
        };

        float4 _OutOfRangeColor;
        float4 _WithInColor;

        void surf (Input IN, inout SurfaceOutputStandard o) {
            float dist = distance(fixed3(0,0,0), IN.worldPos);
            float radius = 2;

            if(radius < dist) {
                o.Albedo = fixed4(_OutOfRangeColor);
            }
            else{
                o.Albedo = fixed4(_WithInColor);
            }
        }
        ENDCG
    }
    FallBack "Diffuse"
}
