Shader "Custom/ContinuousDrawing"
{
    Properties{
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader{
        Tags {"RenderType"="Opaque"} 
        LOD 200                      
        Cull off // カリングをオフに設定し、両面を描画
        Blend SrcAlpha OneMinusSrcAlpha // アルファブレンディングを設定

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog
            #include "UnityCG.cginc"

            // 頂点データの入力構造体
            struct appdata
            {
                float4 vertex : POSITION; // 頂点座標
                float2 uv : TEXCOORD0; // UV座標
            };

            // 頂点シェーダの出力およびフラグメントシェーダの入力構造体
            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            // 頂点シェーダ: モデル空間の頂点をクリップ空間に変換
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o, o.vertex);
                return o;
            }

            // フラグメントシェーダ: 各ピクセルの色を計算
            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                UNITY_APPLY_FOG(i.fogColor, col); // フォグの影響を色に適用
                return col;
            }
            ENDCG
        }           
    }
}
