Shader "Custom/rim"
{
    Properties {
        _Color ("Base Color", Color) = (1,1,1,1)
        _RimColor ("Rim Color", Color) = (255, 0, 0, 255)
        _RimPower ("Rim Power", Float) = 9.5
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard
        #pragma target 3.0

        float4 _Color;
        float4 _RimColor;
        float _RimPower;

        struct Input {
            float2 uv_MainTex;
            float3 worldNormal;
            float3 viewDir;
        };

        void surf (Input IN, inout SurfaceOutputStandard o) {

            o.Albedo = _Color;

            float3 normal = normalize(IN.worldNormal);
            float3 viewDir = normalize(IN.viewDir);

            float rim = 1.0 - saturate(dot(viewDir, normal)); // 0�`1�͈̔͂ŁA���ς̌��ʂ𔽓]
            o.Emission = _RimColor.rgb * pow(rim, _RimPower); // �����̋��x�Ɋ�ăG�~�b�V������ݒ�
        }
        ENDCG
    }
    FallBack "Diffuse"
}