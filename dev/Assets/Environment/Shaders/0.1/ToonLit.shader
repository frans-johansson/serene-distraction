Shader "Roystan/Toon/Lit"
{
    Properties
    {
		_Color("Color", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags 
		{ 
			"RenderType" = "Opaque"
			"LightMode" = "ForwardBase"
		}

		UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase

            #include "UnityCG.cginc"
			#include "Lighting.cginc"
            #include "AutoLight.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
				float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                SHADOW_COORDS(2)
                float2 uv : TEXCOORD0;
				float3 worldNormal : NORMAL;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.worldNormal = normalize(mul((float3x3)UNITY_MATRIX_M, v.normal));
                TRANSFER_SHADOW(o)
                return o;
            }

			float4 _Color;

            float4 frag (v2f i) : SV_Target
            {
				float NdotL = dot(i.worldNormal, _WorldSpaceLightPos0);
				float light = saturate(floor(NdotL * 3) / (2 - 0.5)) * _LightColor0;
                
                float shadow = SHADOW_ATTENUATION(i);

                float lightIntensity = smoothstep(0, 0.01, NdotL * shadow);
                
                float4 col = tex2D(_MainTex, i.uv);
                return (col * _Color) * ((light*lightIntensity) + unity_AmbientSky);
            }
            ENDCG
        }
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}
