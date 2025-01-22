Shader "Custom/BlockNoise"
{
    Properties {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _Speed ("Animation Speed", Float) = 1.0
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
        float _Speed; 

        struct Input{
            float2 uv_MainTex;
        };

        // �����_���l�𐶐�����֐�
        float random (fixed2 p){
            return frac(sin(dot(p, fixed2(12.9898, 78.233))) * 43758.5453);
        }

        // ���͍��W����m�C�Y�𐶐�����֐�
        float noise (fixed2 st) {
             // UV���W�̏����_�ȉ���؂�̂Ă��l���擾�i�O���b�h��̃Z���ɃX�i�b�v�j
            fixed2 p = floor(st);
            return random(p);
        }

        void surf (Input IN, inout SurfaceOutputStandard o) {
            float c = noise(IN.uv_MainTex * 8); // UV���W�ɃX�P�[���i8�{�j�������ăm�C�Y�𐶐�
            c *= 0.5 * 0.5 * sin(_Time.y * _Speed); // ���邳��0.0�`1.0�͈̔͂ŕω�������
            o.Albedo = fixed4(c,c,c,1);
        }
        ENDCG
    }
    FallBack "Diffuse"
}