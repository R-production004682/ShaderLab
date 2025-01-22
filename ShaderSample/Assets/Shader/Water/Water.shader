Shader "Custom/Water"
{
    Properties
    {
        _MainTex("Water Texture", 2D) = "white" {}
        _NoiseTex("Noise Texture", 2D) = "white" {} // ノイズテクスチャを追加
        _WaveSpeedX("WaveSpeedX", Range(0,1))= 0.5
        _WaveSpeedY("WaveSpeedY", Range(0,1))= 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" } // 透明な水面用
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _NoiseTex;
        half _WaveSpeedX;
        half _WaveSpeedY;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            float2 uv = IN.uv_MainTex;

            // UV座標を時間に応じて動かす
            uv.x += _WaveSpeedX * _Time.y;
            uv.y += _WaveSpeedY * _Time.y;

            // ノイズテクスチャを使用して水面の歪みを追加
            float2 noise = tex2D(_NoiseTex, uv * 2.0).rg;
            uv += noise * 0.05;

            // サイン波で水面のゆらぎを追加
            uv.x += sin(uv.y * 5.0 + _Time.y) * 0.05;
            uv.y += cos(uv.x * 5.0 + _Time.y) * 0.05;

            // テクスチャカラーを適用
            o.Albedo = tex2D(_MainTex, uv).rgb;

            // 透明度をノイズに基づいて設定
            o.Alpha = tex2D(_NoiseTex, uv).r * 0.25;
        }
        ENDCG
    }

    FallBack "Diffuse"
}
