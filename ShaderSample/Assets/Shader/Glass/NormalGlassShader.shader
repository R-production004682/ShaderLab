Shader "Custom/NormalGlassShader"
{
    Properties{
        _Alpha("AlphaValue", Range(0, 1)) = 0.5
    }

    SubShader {
        Tags {"Queue"="Transparent"} // 描画の優先度を指定
        LOD 200

        CGPROGRAM
#pragma surface surf Standard alpha:fade
#pragma target 3.0

            struct Input {
                float3 worldNormal; // オブジェクトの表面法線
                float3 viewDir;     // カメラからオブジェクトへの視線方向
            };

            half _Alpha;

            void surf(Input IN, inout SurfaceOutputStandard o) {
                o.Albedo = fixed4(1, 1, 1, 1); // 白いオブジェクト

                // 視線方向と法線の内積の絶対値
                float angleEffect = 1 - abs(dot(IN.viewDir, IN.worldNormal));

                // _Alpha と angleEffect を掛けて透明度を調整
                o.Alpha = _Alpha * angleEffect;
            }
         ENDCG
        }
    FallBack "Diffuse"
}