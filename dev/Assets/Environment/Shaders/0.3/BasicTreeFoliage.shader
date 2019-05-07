// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Foliage/basicWindyTree"
{
	// Material properties includes the coloration of the leaves as well as a gray-scaled texture image
	Properties
	{
		// Leaves and their pretty colors
		_Color("Color", Color) = (1,1,1,1)
		_ReduceShadows("Shadow Reduction", range(0,1)) = 0
		_MainTex("Texture", 2D) = "white" {}
		// Wind variables and noise
		_NoiseTex("Wind Noise", 2D) = "white" {}
		_WindResolution("Wind Resolution", range(50, 500)) = 200
		_WindSpeed("Wind Speed", float) = 10
		_WindStrength("Wind Strength", range(0, 20)) = 0.5
		// For transparancy
		_Cutoff("Alpha cutoff", range(0,1)) = 0.5
	}
	SubShader
	{
		// Pass tags
		Tags { "Queue" = "Transparent" "IgnoreProjector" = "False" "RenderType" = "TransparentCutout" "DisableBatching"="True" }
		// Set the level of detail
		LOD 200
		// Render both sides of the geometry
		Cull off

		CGPROGRAM // Start the CG snippet

		// Using the simple Lambert shading model for diffuse calculations
		// with shadow calculations from multiple light sources
		// and testing for transparancy in the final output 
		#pragma surface surf Standard addshadow fullforwardshadows alphatest:_Cutoff vertex:vert
		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		// Include file for appdata structures and helper functions
		#include "UnityCG.cginc"

		// Bringing in values set by the corresponding properties
		sampler2D _MainTex;
		sampler2D _NoiseTex;
		fixed4 _Color;
		float _ReduceShadows;
		float _WindResolution;
		float _WindSpeed;
		float _WindStrength;

		// Input data structure
		struct Input
		{
			float2 uv_MainTex;	// Used for main leaf texture
		};

		void vert(inout appdata_full v)
		{
			// Calculate world space coordinates
			float3 worldPos = mul(unity_ObjectToWorld, v.vertex);

			// Animated world space UV calculations
			float worldPosUV_x = fmod(worldPos.x + _Time * _WindSpeed, _WindResolution) / _WindResolution;
			float worldPosUV_z = fmod(worldPos.z + _Time * _WindSpeed, _WindResolution) / _WindResolution;
			float2 worldPosUV = float2(worldPosUV_x, worldPosUV_z);

			// Sample wind amount from the noise texture
			float wind = tex2Dlod(_NoiseTex, float4(worldPosUV, 0, 0)).r;
			// Set the values to be on the interval -1, 1
			wind = saturate(wind) * 2 - 1;
			// Amplify the wind somewhat
			wind *= _WindStrength;

			// Calculate vertex movement from wind in world space coordinates
			// Then convert and apply this to the local vertex coordinates 
			v.vertex.xyz -= mul(unity_WorldToObject, normalize(worldPos.xyz + wind));
		}

		// Surface function
		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			// Sampling color values from the texture, tinting by a given color
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			// Apply texture and alpha
			o.Albedo = c.rgb;
			o.Alpha = c.a;
			// Apply a colored emission to reduce internal shadows
      o.Emission = _ReduceShadows * c.rgb;
		}

		ENDCG // End the CG snippet
	}
		FallBack "Diffuse"
}