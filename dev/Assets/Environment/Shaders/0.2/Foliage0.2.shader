// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Foliage/surfaceFoliage"
{
	// Material properties includes the coloration of the leaves as well as a gray-scaled texture image
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Texture", 2D) = "white" {}
	// Used for transparency
	_Cutoff("Alpha cutoff", range(0,1)) = 0.5
	}
		SubShader
	{
		// Pass tags
		Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "TransparentCutout" }
		// Set the level of detail
		LOD 200
		// Render both sides of the geometry
		Cull off

		CGPROGRAM // Start the CG snippet

		// Using the simple Lambert shading model for diffuse calculations
		// with shadow calculations from multiple light sources
		// and testing for transparancy in the final output 
		#pragma surface surf Lambert addshadow alphatest:_Cutoff 
		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		// Include file for appdata structures and helper functions
		#include "UnityCG.cginc"

		// Bringing in values set by the corresponding properties
		sampler2D _MainTex;
		fixed4 _Color;

		// Input data structure
		struct Input
		{
			float2 uv_MainTex;
		};

		// Surface function
		void surf(Input IN, inout SurfaceOutput o)
		{
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		ENDCG // End the CG snippet
	}
		FallBack "Diffuse"
}