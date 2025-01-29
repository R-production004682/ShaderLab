Shader "Custom/Sea"
{
    Properties
    {
        _MainTex("Water Texture", 2D) = "white" {}
        _NoiseTex("Noise Texture", 2D) = "white" {} 
        _WaveSpeedX("Wave Speed X", Range(0,1)) = 0.2
        _WaveSpeedY("Wave Speed Y", Range(0,1)) = 0.2
        _WaveHeight("Wave Height", Range(0, 1)) = 0.1
        _WaveFrequency("Wave Frequency", Range(0,10)) = 5.0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows vertex:vert
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _NoiseTex;
        half _WaveSpeedX;
        half _WaveSpeedY;
        half _WaveHeight;
        half _WaveFrequency;

        struct Input
        {
            float2 uv_MainTex;
        };

        // 波の動きを表現
        void vert(inout appdata_full v)
        {
            float time = _Time.y;

            // X方向とZhoukou の波の動きを作成
            float wave = sin(v.vertex.x * _WaveFrequency + time * _WaveSpeedX * 5.0) * 
                         cos(v.vertex.z * _WaveFrequency + time * _WaveSpeedY * 5.0);

            // 波の高さを作成
            v.vertex.y += wave * _WaveHeight;
        }

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            float2 uv = IN.uv_MainTex;

            // UVのアニメーション
            float time = _Time.y;
            uv.x += _WaveSpeedX * time * 0.2; // X方向の流れ
            uv.y += _WaveSpeedY * time * 0.2; // Y方向の流れ

            // ノイズテクスチャで歪み
            float2 noise = tex2D(_NoiseTex, uv * 3.0).rg;
            uv += (noise - 0.5) * 0.03;

            // ベーステクスチャ
            fixed4 c = tex2D(_MainTex, uv);

            o.Albedo = c.rgb;
            o.Alpha = 0.5 + (noise.r - 0.5) * 0.3;
        }
        ENDCG
    }
    FallBack "Diffuse"
}