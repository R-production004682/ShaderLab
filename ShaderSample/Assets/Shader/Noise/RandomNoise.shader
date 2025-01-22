Shader "Custom/AnimatedRandomNoise"
{
    Properties{
        _MainTex ("Albedo (RGB)", 2D) = "white" {} // �e�N�X�`���v���p�e�B
        _Speed ("Animation Speed", Float) = 1.0    // �m�C�Y�̕ω����x
    }
    SubShader{
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex; // �e�N�X�`���T���v���[���`
        float _Speed;       // �m�C�Y�A�j���[�V�����̑��x�𒲐�����ϐ�

        struct Input{
            float2 uv_MainTex; // UV���W���󂯎��
        };

        // �����_���l�𐶐�����֐�
        float random (fixed2 p){
            return frac(sin(dot(p, fixed2(12.9898, 78.233))) * 43758.5453);
        }

        // �T�[�t�F�X�V�F�[�_�[
        void surf(Input IN, inout SurfaceOutputStandard o){
            // ���Ԃ̌o�߂��擾���A���x�𒲐�
            float time = _Time.y * _Speed; 
            // UV���W�Ɏ��Ԃ������ăm�C�Y�p�^�[����ω�������
            float c = random(IN.uv_MainTex + time);
            // �v�Z�����m�C�Y�l��Albedo�ɐݒ�
            o.Albedo = fixed4(c, c, c, 1);
        }
        ENDCG
    }
    FallBack "Diffuse"
}