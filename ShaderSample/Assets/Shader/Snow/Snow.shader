Shader "Custom/Snow"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _Glossiness("Smoothness", Range(0,1)) = 0.5
        _Metallic("Metallic", Range(0,1)) = 0.0
        _Snow("Snow", Range(0,2)) = 0.0
    }
    SubShader
    {
        Tags {}
        LOD 300

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input{
            float2 uv_MainTex;
            float2 worldNormal;
        };

        half _Glossiness;
        half _Metallic;
        half _Snow;

        fixed4 _Color;

        void surf(Input IN, inout SurfaceOutputStandard o) {
            // ワールド空間の法線と上方向（0, 1, 0）の内積を計算
            float d = dot(IN.worldNormal, fixed3(0,1,0));
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            fixed4 white = fixed4(1,1,1,1);

            // ベースカラーと白色を補間（雪の影響をシミュレーション）
            // d（上向きの度合い）と _Snow（雪の強さ）を掛けた値で補間率を決定
            c = lerp(c, white, d * _Snow);

            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
