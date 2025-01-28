Shader "Custom/Topology"
{
    Properties
    {
        _PointColorA("_PointColorA", Color) = (1,1,1,1)
        _PointColorB("_PointColorB", Color) = (1,1,1,1)
        _Displacement("Impact", Float) = 0.0
    }
    SubShader
    {
        Tags{"RenderType"="Transparent"}
        Cull Off // �w�ʃJ�����O�𖳌���
        ZWrite On // �[�x�o�b�t�@�ւ̏������݂�L����
        Blend SrcAlpha OneMinusSrcAlpha // �A���t�@�u�����h��ݒ�i�������`��j
        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 worldPos : TEXCOORD0;
            };

            float4 _Color;
            float4 _PointColorA;
            float4 _PointColorB;

            float _Displacement;

            v2f vert(appdata_base v)
            {
                v2f o;
                float3 n = UnityObjectToWorldNormal(v.normal);

                // ���_�̍��W���N���b�v��Ԃɕϊ�
                o.pos = UnityObjectToClipPos(v.vertex) + float4(n * _Displacement, 0);
                // ���_�̃��[���h��Ԉʒu���v�Z
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

                return o;
            }

            half4 frag(v2f i) : COLOR
            {
                float4 colorA  = _PointColorA;
            	float4 colorB = _PointColorB;
                
                // Y���W�Ɋ�Â��ău�����h���A�F������
                return lerp(colorA, colorB, i.worldPos.y * 0.2);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
