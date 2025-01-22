Shader "Custom/RealTextureShader"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}  // メインのベーステクスチャ
        _NormalMap("Normal Map", 2D) = "bump" {}  // ノーマルマップ用テクスチャ
        _Metallic("Metallic", Range(0, 1)) = 0.5  // メタリック度
        _Smoothness("Smoothness", Range(0, 1)) = 0.5  // スムースネス（テカリ具合）
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 500

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;      // UV座標（メインテクスチャ用）
            float2 uv_NormalMap;    // UV座標（ノーマルマップ用）
        };

        sampler2D _MainTex;         // メインテクスチャ
        sampler2D _NormalMap;       // ノーマルマップ
        half _Metallic;             // メタリック値
        half _Smoothness;           // スムースネス値

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            // メインテクスチャをアルベドに適用
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;

            // ノーマルマップを適用（凹凸表現）
            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));

            // メタリックとスムースネスを適用（テカり表現）
            o.Metallic = _Metallic;
            o.Smoothness = _Smoothness;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
