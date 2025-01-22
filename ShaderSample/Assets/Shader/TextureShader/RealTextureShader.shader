Shader "Custom/RealTextureShader"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}  // ���C���̃x�[�X�e�N�X�`��
        _NormalMap("Normal Map", 2D) = "bump" {}  // �m�[�}���}�b�v�p�e�N�X�`��
        _Metallic("Metallic", Range(0, 1)) = 0.5  // ���^���b�N�x
        _Smoothness("Smoothness", Range(0, 1)) = 0.5  // �X���[�X�l�X�i�e�J����j
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 500

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;      // UV���W�i���C���e�N�X�`���p�j
            float2 uv_NormalMap;    // UV���W�i�m�[�}���}�b�v�p�j
        };

        sampler2D _MainTex;         // ���C���e�N�X�`��
        sampler2D _NormalMap;       // �m�[�}���}�b�v
        half _Metallic;             // ���^���b�N�l
        half _Smoothness;           // �X���[�X�l�X�l

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            // ���C���e�N�X�`�����A���x�h�ɓK�p
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;

            // �m�[�}���}�b�v��K�p�i���ʕ\���j
            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));

            // ���^���b�N�ƃX���[�X�l�X��K�p�i�e�J��\���j
            o.Metallic = _Metallic;
            o.Smoothness = _Smoothness;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
