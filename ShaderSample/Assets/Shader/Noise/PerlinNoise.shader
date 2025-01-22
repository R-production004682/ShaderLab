Shader "Custom/PerlinNoise"
{
    Properties{
        _MainTex("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader{
        Tags {"RenderType"="Opaque"}
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input {
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

            // 近傍点間の補間
            return lerp( lerp( dot( v00, f - fixed2(0,0) ), dot( v10, f - fixed2(1,0) ), u.x ),
                         lerp( dot( v01, f - fixed2(0,1) ), dot( v11, f - fixed2(1,1) ), u.x ), u.y)+0.5f;
        }

        void surf(Input IN, inout SurfaceOutputStandard o) {
            float c = perlinNoise(IN.uv_MainTex * 8);
            o.Albedo = fixed4(c,c,c,1);
            o.Metallic = 0;
            o.Smoothness = 0;
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}