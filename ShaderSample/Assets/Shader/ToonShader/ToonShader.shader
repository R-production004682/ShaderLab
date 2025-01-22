Shader "Custom/ToonShader"
{
 Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _RampColor1("Ramp Start Color", Color) = (0,0,0,1) // ランプの開始色
        _RampColor2("Ramp End Color", Color) = (1,1,1,1)   // ランプの終了色
        _RampThreshold("Ramp Threshold", Range(0,1)) = 0.5 // 明暗の閾値
    }
    SubShader 
    {
        Tags {"RenderType"="Opaque"}
        LOD 200

        CGPROGRAM
        #pragma surface surf ToonDynamic
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _Color;
        fixed4 _RampColor1;
        fixed4 _RampColor2;
        float _RampThreshold;

        // トゥーン調ライティングを計算する関数
        fixed4 LightingToonDynamic(SurfaceOutput s, fixed3 lightDir, fixed atten)
        {
            // 法線と光の方向の内積を計算して、0～1の範囲に正規化
            half d = dot(s.Normal, lightDir) * 0.5 + 0.5;

            // 閾値を使用してランプ色を線形補間で決定
            fixed t = step(_RampThreshold, d); // 閾値に基づいてスイッチ
            fixed3 ramp = lerp(_RampColor1.rgb, _RampColor2.rgb, t); // 色を補間

            // 最終的なライティング結果を計算
            fixed4 c;
            c.rgb = s.Albedo * _LightColor0.rgb * ramp; // アルベド × 光の色 × ランプ色
            c.a = 0;
            return c;
        }

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}