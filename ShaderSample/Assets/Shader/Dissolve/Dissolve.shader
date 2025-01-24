Shader "Custom/Dissolve"
{
    Properties
    {
        _Color ("Color",Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _DisolveTex ("DisolveTex (RGB)", 2D) = "white" {}  // �f�B�]���u���ʗp�̃}�X�N�e�N�X�`��
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _Threshold ("Threshold", Range(0,1)) = 0.0 // �f�B�]���u�̂������l (0: ���S�\���A1: ���S����)
    }
    SubShader
    {
        Tags {"RenderType" = "Opaque"}
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _DisolveTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        half _Threshold;
        fixed4 _Color;

        // Unity�̃C���X�^���V���O�p�o�b�t�@ (�I�v�V����)
        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // �f�B�]���u�}�X�N�e�N�X�`�����猻�݂̃s�N�Z���̐F���擾
            fixed4 m = tex2D (_DisolveTex, IN.uv_MainTex);

            // �}�X�N�e�N�X�`����RGB�����d���ς��ăO���[�X�P�[���l���v�Z
            half g = m.r * 0.2 + m.g * 0.7 + m.b * 0.1;
            
            if(g < _Threshold)
            {
                discard;
            }

            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}