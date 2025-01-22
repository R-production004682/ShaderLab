Shader "Custom/ToonShader"
{
 Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _RampColor1("Ramp Start Color", Color) = (0,0,0,1) // �����v�̊J�n�F
        _RampColor2("Ramp End Color", Color) = (1,1,1,1)   // �����v�̏I���F
        _RampThreshold("Ramp Threshold", Range(0,1)) = 0.5 // ���Â�臒l
    }
    SubShader 
    {
        Tags {"RenderType"="Opaque"}
        LOD 200

        CGPROGRAM
        #pragma surface surf ToonDynamic
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _Color;
        fixed4 _RampColor1;
        fixed4 _RampColor2;
        float _RampThreshold;

        // �g�D�[�������C�e�B���O���v�Z����֐�
        fixed4 LightingToonDynamic(SurfaceOutput s, fixed3 lightDir, fixed atten)
        {
            // �@���ƌ��̕����̓��ς��v�Z���āA0�`1�͈̔͂ɐ��K��
            half d = dot(s.Normal, lightDir) * 0.5 + 0.5;

            // 臒l���g�p���ă����v�F����`��ԂŌ���
            fixed t = step(_RampThreshold, d); // 臒l�Ɋ�Â��ăX�C�b�`
            fixed3 ramp = lerp(_RampColor1.rgb, _RampColor2.rgb, t); // �F����

            // �ŏI�I�ȃ��C�e�B���O���ʂ��v�Z
            fixed4 c;
            c.rgb = s.Albedo * _LightColor0.rgb * ramp; // �A���x�h �~ ���̐F �~ �����v�F
            c.a = 0;
            return c;
        }

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}