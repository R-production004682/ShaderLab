Shader "Custom/NormalGlassShader"
{
    Properties{
        _Alpha("AlphaValue", Range(0, 1)) = 0.5
    }

    SubShader {
        Tags {"Queue"="Transparent"} // �`��̗D��x���w��
        LOD 200

        CGPROGRAM
#pragma surface surf Standard alpha:fade
#pragma target 3.0

            struct Input {
                float3 worldNormal; // �I�u�W�F�N�g�̕\�ʖ@��
                float3 viewDir;     // �J��������I�u�W�F�N�g�ւ̎�������
            };

            half _Alpha;

            void surf(Input IN, inout SurfaceOutputStandard o) {
                o.Albedo = fixed4(1, 1, 1, 1); // �����I�u�W�F�N�g

                // ���������Ɩ@���̓��ς̐�Βl
                float angleEffect = 1 - abs(dot(IN.viewDir, IN.worldNormal));

                // _Alpha �� angleEffect ���|���ē����x�𒲐�
                o.Alpha = _Alpha * angleEffect;
            }
         ENDCG
        }
    FallBack "Diffuse"
}