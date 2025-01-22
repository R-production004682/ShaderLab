Shader "Custom/GlassShader"
{
 Properties
    {
        _Alpha("AlphaValue", Range(0, 1)) = 0.5
        _ReflectionColor ("Reflection Color", Color) = (1, 1, 1, 1)
        _CubeMap ("Environment Cubemap", Cube) = "" {} // ���}�b�s���O�p�L���[�u�}�b�v

        _Color("BaseColor",Color) = (1,1,1,1)
        _RimColor("Rim Color", Color) = (255 ,0 ,0 ,255)
        _RimPower("Rim Power", Float) = 9.5
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }
        LOD 200

        CGPROGRAM
#pragma surface surf Standard alpha:fade
#pragma target 3.0

        samplerCUBE _CubeMap;
        float4 _ReflectionColor;
        float4 _Color;
        float4 _RimColor;
        float _RimPower;

        struct Input
        {
            float3 worldNormal; // ���[���h��Ԃ̖@��
            float3 viewDir;     // ���[���h��Ԃ̎�������
        };

        half _Alpha;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // ���ʔ��˂̌v�Z
            float3 worldNormal = normalize(IN.worldNormal);
            float3 viewDir = normalize(IN.viewDir);
            float3 reflectionVector = reflect(-viewDir, worldNormal); // ���˃x�N�g��
            fixed4 reflection = texCUBE(_CubeMap, reflectionVector) * _ReflectionColor;

            o.Albedo = reflection.rgb; // ���ʔ��ːF�𒼐ڃA���x�h�ɐݒ�
            float angleEffect = 1 - abs(dot(viewDir, worldNormal)); // ���������Ɩ@���̓��ς̐�Βl
            o.Alpha = _Alpha * angleEffect; // _Alpha �� angleEffect ���|���ē����x�𒲐�


            // �������C�e�B���O
            float rim = 1.0 - saturate(dot(viewDir, worldNormal));
            o.Emission = _RimColor.rgb * pow(rim, _RimPower);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
