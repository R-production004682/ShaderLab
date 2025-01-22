Shader "Custom/Ring"
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
            float radius = 2;

            if(radius < dist && dist < radius + 0.2) {
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
