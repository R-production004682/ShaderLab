Shader "Custom/GLSLtoShaderLab"
{
    Properties
    {
        _TimeSpeed ("Time Speed", Float) = 1.0 // 時間の速度
        _Color ("Color", Color) = (1,0.5,0.2,1) // カラー設定
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0

            float4 _Color;       // カラー設定
            float _TimeSpeed;    // 時間の速度

            struct appdata
            {
                float4 vertex : POSITION; // 頂点座標
                float2 uv : TEXCOORD0;    // UV 座標
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;    // UV 座標
                float4 pos : SV_POSITION; // クリップ空間の頂点座標
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex); // 頂点をクリップ空間に変換
                o.uv = v.uv; // UV 座標をそのまま渡す
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // 入力 UV 座標を正規化
                float2 p = i.uv;

                // 縦横比を考慮してスケーリング
                p /= float2(1.0, 1.0); // ここを画面解像度で置き換える場合は Unity の `_ScreenParams` を使う

                // 時間変化を適用して座標を変形
                float2 a = p * 5.0; 
                a.y -= _Time.y * _TimeSpeed;

                // フラクション（小数部分）と整数部分を分離
                float2 f = frac(a); 
                a -= f;

                // 3次エルミート関数を使い、緩やかに補間させる（スムージング）
                f = f * f * (3.0 - 2.0 * f);

                // 乱数生成（sin を利用した疑似乱数）
                float4 r = frac(sin(float4(a.x + a.y * 1e3, 
                                           a.x + a.y * 1e3 + 1.0, 
                                           a.x + a.y * 1e3 + 1e3, 
                                           a.x + a.y * 1e3 + 1001.0)) * 1e5) * 30.0 / p.y;

                // 色を計算
                float3 baseColor = p.y + _Color.rgb * clamp(lerp(lerp(r.x, r.y, f.x),
                                                      lerp(r.z, r.w, f.x), f.y) - 30.0, -0.2, 1.0);

                return float4(baseColor, 1.0); // 最終色
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
