Shader "Custom/sample" {
    Properties {
        _MainTex ("Main Texture", 2D) = "white" {}
        _SubTex ("Sub Texture", 2D) = "white" {}
        _MaskTex ("Mask Texture", 2D) = "white" {}
        _NormalMap("NormalMap", 2D) = "white" {}
        _MaskStrength ("Mask Strength", Range(0, 1)) = 1.0
        _Smoothness ("Smoothness", Range(0, 1)) = 0.5
        _Metallic("Metallic", Range(0,1)) = 0.5
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _SubTex;
        sampler2D _MaskTex;
        sampler2D _NormalMap;
        float _MaskStrength;
        float _Smoothness;
        half _Metallic;

        struct Input {
            float2 uv_MainTex;
            float2 uv_NormalMap;
        };

        void surf (Input IN, inout SurfaceOutputStandard o) {
            fixed4 c1 = tex2D(_MainTex, IN.uv_MainTex);
            fixed4 c2 = tex2D(_SubTex, IN.uv_MainTex);
            fixed4 mask = tex2D(_MaskTex, IN.uv_MainTex);

            // マスクのスムーズさを反映
            float adjustedMask = smoothstep(0.5 - _Smoothness, 0.5 + _Smoothness, mask.r);

            // マスク強度を反映
            adjustedMask *= _MaskStrength;

            // ノーマルマップの取得
            fixed4 normalSample = tex2D(_NormalMap, IN.uv_NormalMap);
            o.Normal = UnpackNormal(normalSample);

            o.Albedo = lerp(c1, c2, adjustedMask);
            o.Metallic = _Metallic;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
