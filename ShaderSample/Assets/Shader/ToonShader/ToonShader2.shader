Shader "Custom/ToonShader"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _RampTex ("Ramp", 2D) = "white" {}
    }
    SubShader 
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        
        CGPROGRAM
        #pragma surface surf ToonRamp
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _RampTex;

        struct Input {
            float2 uv_MainTex;
        };

        fixed4 _Color;

        // トゥーン調ライティングを計算する関数
        fixed4 LightingToonRamp (SurfaceOutput s, fixed3 lightDir, fixed atten)
        {
             // 法線と光の方向の内積を計算し、0～1の範囲に正規化
            half d = dot(s.Normal, lightDir)*0.5 + 0.5;

            // ランプテクスチャを使用して明暗の色を取得
            fixed3 ramp = tex2D(_RampTex, fixed2(d, 0.5)).rgb;

             // ライティング結果を計算
            fixed4 c;
            c.rgb = s.Albedo * _LightColor0.rgb * ramp; // アルベド色 × ランプ色 × 光の色
            c.a = 0;
            return c;
        }

        void surf (Input IN, inout SurfaceOutput o) {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
