Shader "Custom/fBmNoise"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed2 random2(fixed2 st){
            st = fixed2(dot(st, fixed2(127.1, 311.7)),dot(st, fixed2(269.5, 183.3)));
            return -1.0 + 2.0 * frac(sin(st) * 43758.543123);
        }

        // 2D空間でのパーリンノイズを生成する関数。
        float perlinNoise(fixed2 st) {

            // 座標を整数部分と小数部分に分割。
            fixed2 p = floor(st);
            fixed2 f = frac(st);

            // 平滑化のための補間関数 (u) を計算
            fixed2 u = f*f*(3.0-2.0*f);

            // 2つの方向（x軸とy軸）で補間
            float v00 = random2(p + fixed2(0,0));
            float v10 = random2(p + fixed2(1,0));
            float v01 = random2(p + fixed2(0,1));
            float v11 = random2(p + fixed2(1,1));

            // x方向とy方向に沿った線形補間（双線形補間）
            return lerp( lerp( dot( v00, f - fixed2(0,0) ), dot( v10, f - fixed2(1,0) ), u.x ),
                         lerp( dot( v01, f - fixed2(0,1) ), dot( v11, f - fixed2(1,1) ), u.x ), u.y)+0.5f;// 値を0.0〜1.0の範囲に調整
        }
        
        // フラクタル・ブラウン運動（fBm）ノイズを生成
        float fBm(fixed2 st) {
            float f = 0;
            fixed2 q = st;

            // 複数のスケールとウェイトを適用して累積ノイズを計算
            f += perlinNoise(q) * 0.5000; // 最初のスケール（ウェイト: 0.5）
            q = q * 2.01;
            
            f += perlinNoise(q) * 0.2500; // 2番目のスケール（ウェイト: 0.25）
            q = q * 2.02;
            
            f += perlinNoise(q) * 0.1250; // 3番目のスケール（ウェイト: 0.125）
            q = q * 2.03;
            
            f += perlinNoise(q) * 0.0625; // 4番目のスケール（ウェイト: 0.0625）
            q = q * 2.01;

            return f; // 累積されたノイズを返す
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float c = fBm(IN.uv_MainTex * 6);
            o.Albedo = fixed4(c,c,c,1);
            o.Metallic = 0;
            o.Smoothness = 0;
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
