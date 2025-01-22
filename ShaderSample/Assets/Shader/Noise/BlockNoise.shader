Shader "Custom/BlockNoise"
{
    Properties {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _Speed ("Animation Speed", Float) = 1.0
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
        float _Speed; 

        struct Input{
            float2 uv_MainTex;
        };

        // ランダム値を生成する関数
        float random (fixed2 p){
            return frac(sin(dot(p, fixed2(12.9898, 78.233))) * 43758.5453);
        }

        // 入力座標からノイズを生成する関数
        float noise (fixed2 st) {
             // UV座標の小数点以下を切り捨てた値を取得（グリッド状のセルにスナップ）
            fixed2 p = floor(st);
            return random(p);
        }

        void surf (Input IN, inout SurfaceOutputStandard o) {
            float c = noise(IN.uv_MainTex * 8); // UV座標にスケール（8倍）をかけてノイズを生成
            c *= 0.5 * 0.5 * sin(_Time.y * _Speed); // 明るさを0.0～1.0の範囲で変化させる
            o.Albedo = fixed4(c,c,c,1);
        }
        ENDCG
    }
    FallBack "Diffuse"
}