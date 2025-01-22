Shader "Custom/DartShader"
{
   Properties
   {
       _MainTex("MainTexture", 2D) = "white" {}
       _NormalMap("NormalMap", 2D) = "bump" {}
       _Metallic("Metallic", Range(0,1)) = 0.5
       _Smoothness("Smooth", Range(0,1)) = 0.5
   }
   SubShader
   {
       Tags{ "RenderType"="Opaque" }
       LOD 500

       CGPROGRAM
       #pragma surface surf Standard fullforwardshadows
       #pragma target 3.0

       struct Input
       {
           float2 uv_MainTex;
           float2 uv_NormalMap;
       };

       sampler2D _MainTex;
       sampler2D _NormalMap;
       half _Metallic;
       half _Smoothness;

       void surf(Input IN, inout SurfaceOutputStandard o)
       {
           o.Albedo = tex2D(_MainTex, IN.uv_NormalMap);
           o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
           o.Metallic = _Metallic;
           o.Smoothness = _Smoothness;
       }
       ENDCG
   }

    FallBack "Diffuse"
}
