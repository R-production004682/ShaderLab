Shader "Custom/Dissolve"
{
    Properties
    {
        _Color ("Color",Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _DisolveTex ("DisolveTex (RGB)", 2D) = "white" {}  // ディゾルブ効果用のマスクテクスチャ
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _Threshold ("Threshold", Range(0,1)) = 0.0 // ディゾルブのしきい値 (0: 完全表示、1: 完全消滅)
    }
    SubShader
    {
        Tags {"RenderType" = "Opaque"}
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _DisolveTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        half _Threshold;
        fixed4 _Color;

        // Unityのインスタンシング用バッファ (オプション)
        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // ディゾルブマスクテクスチャから現在のピクセルの色を取得
            fixed4 m = tex2D (_DisolveTex, IN.uv_MainTex);

            // マスクテクスチャのRGBを加重平均してグレースケール値を計算
            half g = m.r * 0.2 + m.g * 0.7 + m.b * 0.1;
            
            if(g < _Threshold)
            {
                discard;
            }

            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}