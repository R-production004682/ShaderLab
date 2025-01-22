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

        // �����_���l�𐶐�����֐�
        float random (fixed2 p) {
            return frac(sin(dot(p, fixed2(12.9898, 78.233))) * 43758.5453);
        }

        // �O���b�h�̐������W���x�[�X�Ƀ����_���l���擾
        float noise(fixed2 st){
            fixed2 p = floor(st);
            return random(p);
        }

       // �O���b�h�Ɋ�Â����������ꂽ�m�C�Y�𐶐�
        float ValueNoise(fixed2 st) {
            fixed2 p = floor(st); // ���W�̐����������v�Z
            fixed2 f = frac(st); // ���W�̏����������v�Z

            // �O���b�h��4���̃����_���l���擾
            float v00 = random(p + fixed2(0,0)); // ���_
            float v10 = random(p + fixed2(1,0)); // x+1
            float v01 = random(p + fixed2(0,1)); // y+1
            float v11 = random(p + fixed2(1,1)); // x+1, y+1

            // �������̂��߂̕�Ԋ֐� (u) ���v�Z
            fixed2 u = f * f * (3.0 - 2.0 * f);

            // 2�̕����ix����y���j�ŕ��
            float v0010 = lerp(v00 , v10 , u.x); // x�����̕��
            float v0111 = lerp(v01 , v11 , u.x); // y�����̕��
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