Shader "Custom/GlassShader"
{
 Properties
    {
        _Alpha("AlphaValue", Range(0, 1)) = 0.5
        _ReflectionColor ("Reflection Color", Color) = (1, 1, 1, 1)
        _CubeMap ("Environment Cubemap", Cube) = "" {} // 環境マッピング用キューブマップ

        _Color("BaseColor",Color) = (1,1,1,1)
        _RimColor("Rim Color", Color) = (255 ,0 ,0 ,255)
        _RimPower("Rim Power", Float) = 9.5
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }
        LOD 200

        CGPROGRAM
#pragma surface surf Standard alpha:fade
#pragma target 3.0

        samplerCUBE _CubeMap;
        float4 _ReflectionColor;
        float4 _Color;
        float4 _RimColor;
        float _RimPower;

        struct Input
        {
            float3 worldNormal; // ワールド空間の法線
            float3 viewDir;     // ワールド空間の視線方向
        };

        half _Alpha;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // 鏡面反射の計算
            float3 worldNormal = normalize(IN.worldNormal);
            float3 viewDir = normalize(IN.viewDir);
            float3 reflectionVector = reflect(-viewDir, worldNormal); // 反射ベクトル
            fixed4 reflection = texCUBE(_CubeMap, reflectionVector) * _ReflectionColor;

            o.Albedo = reflection.rgb; // 鏡面反射色を直接アルベドに設定
            float angleEffect = 1 - abs(dot(viewDir, worldNormal)); // 視線方向と法線の内積の絶対値
            o.Alpha = _Alpha * angleEffect; // _Alpha と angleEffect を掛けて透明度を調整


            // リムライティング
            float rim = 1.0 - saturate(dot(viewDir, worldNormal));
            o.Emission = _RimColor.rgb * pow(rim, _RimPower);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
