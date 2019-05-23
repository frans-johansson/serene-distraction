Shader "Puzzles/Runes" {
	Properties {
		_Color ("Color", Color) = (1, 1, 1, 1)
		_Emission("Emission amount", range(0,1)) = 0.5
		_MainTex ("Texture", 2D) = "white" {}
		_AlphaCutoff("Alpha Cutoff", range(0,1)) = 0.8
	}
	SubShader {
		Tags { "RenderType"="Transparent" "Queue" = "Transparent" "ForceNoShadowCasting"="True" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert alphatest:_AlphaCutoff

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		struct Input {
			float2 uv_MainTex;
		};

		fixed4 _Color;
		half _Emission;
		sampler2D _MainTex;

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
			o.Emission = c.rgb * _Emission;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
