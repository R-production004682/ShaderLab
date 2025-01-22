Shader "Custom/AnimatedRandomNoise"
{
    Properties{
        _MainTex ("Albedo (RGB)", 2D) = "white" {} // テクスチャプロパティ
        _Speed ("Animation Speed", Float) = 1.0    // ノイズの変化速度
    }
    SubShader{
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex; // テクスチャサンプラーを定義
        float _Speed;       // ノイズアニメーションの速度を調整する変数

        struct Input{
            float2 uv_MainTex; // UV座標を受け取る
        };

        // ランダム値を生成する関数
        float random (fixed2 p){
            return frac(sin(dot(p, fixed2(12.9898, 78.233))) * 43758.5453);
        }

        // サーフェスシェーダー
        void surf(Input IN, inout SurfaceOutputStandard o){
            // 時間の経過を取得し、速度を調整
            float time = _Time.y * _Speed; 
            // UV座標に時間を加えてノイズパターンを変化させる
            float c = random(IN.uv_MainTex + time);
            // 計算したノイズ値をAlbedoに設定
            o.Albedo = fixed4(c, c, c, 1);
        }
        ENDCG
    }
    FallBack "Diffuse"
}