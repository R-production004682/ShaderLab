Shader "Custom/ContinuousDrawing"
{
    Properties{
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader{
        Tags {"RenderType"="Opaque"} 
        LOD 200                      
        Cull off // �J�����O���I�t�ɐݒ肵�A���ʂ�`��
        Blend SrcAlpha OneMinusSrcAlpha // �A���t�@�u�����f�B���O��ݒ�

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog
            #include "UnityCG.cginc"

            // ���_�f�[�^�̓��͍\����
            struct appdata
            {
                float4 vertex : POSITION; // ���_���W
                float2 uv : TEXCOORD0; // UV���W
            };

            // ���_�V�F�[�_�̏o�͂���уt���O�����g�V�F�[�_�̓��͍\����
            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            // ���_�V�F�[�_: ���f����Ԃ̒��_���N���b�v��Ԃɕϊ�
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o, o.vertex);
                return o;
            }

            // �t���O�����g�V�F�[�_: �e�s�N�Z���̐F���v�Z
            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                UNITY_APPLY_FOG(i.fogColor, col); // �t�H�O�̉e����F�ɓK�p
                return col;
            }
            ENDCG
        }           
    }
}
