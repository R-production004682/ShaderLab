Shader "Custom/ValueNoise"
{
    Properties {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullfouwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
        
        struct Input {
            float2 uv_MainTex;
        };

        // ランダム値を生成する関数
        float random (fixed2 p) {
            return frac(sin(dot(p, fixed2(12.9898, 78.233))) * 43758.5453);
        }

        // グリッドの整数座標をベースにランダム値を取得
        float noise(fixed2 st){
            fixed2 p = floor(st);
            return random(p);
        }

       // グリッドに基づく平滑化されたノイズを生成
        float ValueNoise(fixed2 st) {
            fixed2 p = floor(st); // 座標の整数部分を計算
            fixed2 f = frac(st); // 座標の小数部分を計算

            // グリッドの4隅のランダム値を取得
            float v00 = random(p + fixed2(0,0)); // 原点
            float v10 = random(p + fixed2(1,0)); // x+1
            float v01 = random(p + fixed2(0,1)); // y+1
            float v11 = random(p + fixed2(1,1)); // x+1, y+1

            // 平滑化のための補間関数 (u) を計算
            fixed2 u = f * f * (3.0 - 2.0 * f);

            // 2つの方向（x軸とy軸）で補間
            float v0010 = lerp(v00 , v10 , u.x); // x方向の補間
            float v0111 = lerp(v01 , v11 , u.x); // y方向の補間
            return lerp(v0010, v0111, u.y);
        }

        void surf(Input IN, inout SurfaceOutputStandard o) {
            float c = ValueNoise(IN.uv_MainTex * 8);
            o.Albedo = fixed4(c,c,c,1);
        }
        ENDCG
    }
    FallBack "Diffuse"
}