Shader "Custom/GLSLtoShaderLab"
{
    Properties
    {
        _TimeSpeed ("Time Speed", Float) = 1.0 // ���Ԃ̑��x
        _Color ("Color", Color) = (1,0.5,0.2,1) // �J���[�ݒ�
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

            float4 _Color;       // �J���[�ݒ�
            float _TimeSpeed;    // ���Ԃ̑��x

            struct appdata
            {
                float4 vertex : POSITION; // ���_���W
                float2 uv : TEXCOORD0;    // UV ���W
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;    // UV ���W
                float4 pos : SV_POSITION; // �N���b�v��Ԃ̒��_���W
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex); // ���_���N���b�v��Ԃɕϊ�
                o.uv = v.uv; // UV ���W�����̂܂ܓn��
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // ���� UV ���W�𐳋K��
                float2 p = i.uv;

                // �c������l�����ăX�P�[�����O
                p /= float2(1.0, 1.0); // ��������ʉ𑜓x�Œu��������ꍇ�� Unity �� `_ScreenParams` ���g��

                // ���ԕω���K�p���č��W��ό`
                float2 a = p * 5.0; 
                a.y -= _Time.y * _TimeSpeed;

                // �t���N�V�����i���������j�Ɛ��������𕪗�
                float2 f = frac(a); 
                a -= f;

                // 3���G���~�[�g�֐����g���A�ɂ₩�ɕ�Ԃ�����i�X���[�W���O�j
                f = f * f * (3.0 - 2.0 * f);

                // ���������isin �𗘗p�����^�������j
                float4 r = frac(sin(float4(a.x + a.y * 1e3, 
                                           a.x + a.y * 1e3 + 1.0, 
                                           a.x + a.y * 1e3 + 1e3, 
                                           a.x + a.y * 1e3 + 1001.0)) * 1e5) * 30.0 / p.y;

                // �F���v�Z
                float3 baseColor = p.y + _Color.rgb * clamp(lerp(lerp(r.x, r.y, f.x),
                                                      lerp(r.z, r.w, f.x), f.y) - 30.0, -0.2, 1.0);

                return float4(baseColor, 1.0); // �ŏI�F
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
