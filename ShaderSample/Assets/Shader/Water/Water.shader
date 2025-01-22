Shader "Custom/Water"
{
    Properties
    {
        _MainTex("Water Texture", 2D) = "white" {}
        _NoiseTex("Noise Texture", 2D) = "white" {} // �m�C�Y�e�N�X�`����ǉ�
        _WaveSpeedX("WaveSpeedX", Range(0,1))= 0.5
        _WaveSpeedY("WaveSpeedY", Range(0,1))= 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" } // �����Ȑ��ʗp
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _NoiseTex;
        half _WaveSpeedX;
        half _WaveSpeedY;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            float2 uv = IN.uv_MainTex;

            // UV���W�����Ԃɉ����ē�����
            uv.x += _WaveSpeedX * _Time.y;
            uv.y += _WaveSpeedY * _Time.y;

            // �m�C�Y�e�N�X�`�����g�p���Đ��ʂ̘c�݂�ǉ�
            float2 noise = tex2D(_NoiseTex, uv * 2.0).rg;
            uv += noise * 0.05;

            // �T�C���g�Ő��ʂ̂�炬��ǉ�
            uv.x += sin(uv.y * 5.0 + _Time.y) * 0.05;
            uv.y += cos(uv.x * 5.0 + _Time.y) * 0.05;

            // �e�N�X�`���J���[��K�p
            o.Albedo = tex2D(_MainTex, uv).rgb;

            // �����x���m�C�Y�Ɋ�Â��Đݒ�
            o.Alpha = tex2D(_NoiseTex, uv).r * 0.25;
        }
        ENDCG
    }

    FallBack "Diffuse"
}
