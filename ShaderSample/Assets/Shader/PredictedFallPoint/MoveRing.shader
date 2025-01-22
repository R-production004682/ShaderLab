Shader "Custom/MoveRing"
{
   Properties {
        _OtherColor ("other Colr", Color) = (1,1,1,1)
        _RingColor ("ring Color",Color) = (1,1,1,1)
    }
    SubShader {
        Tags { "RenderType" = "Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard
        #pragma target 3.0

        struct Input {
            float3 worldPos;
        };

        float4 _OtherColor;
        float4 _RingColor;

        void surf (Input IN, inout SurfaceOutputStandard o) {
            float dist = distance(fixed3(0,0,0), IN.worldPos);
            float val = abs(sin(dist * 0.5f - _Time * 60));
            if(val > 0.98) {
                o.Albedo = fixed4(_RingColor);
            }
            else {
                o.Albedo = fixed4(_OtherColor);
            }
        }
        ENDCG
    }
    FallBack "Diffuse"
}
