Shader "Unlit/newWater"
{
    Properties
    {
        // Water color and depth
        _ShallowColorDay ("Shallow Color Day", Color) = (0.7, 0.5, 0.8, 1.0)
        _DeepColorDay ("Deep Color Day", Color) = (0.2, 0.1, 0.8, 1.0)
		_ShallowColorNight("Shallow Color Night", Color) = (0.7, 0.5, 0.8, 1.0)
		_DeepColorNight("Deep Color Night", Color) = (0.2, 0.1, 0.8, 1.0)
        _MaxDepth ("Maximum Depth", range(1, 50)) = 1
        _Opacity ("Opacity", range(0, 1)) = 0.5
        // Foamy noise effect
        _SurfaceFoamNoise ("Surface Foam Noise", 2D) = "white" {}
		_SurfaceFoamCutoff("Cutoff", range(0, 1)) = 0.5
		_SurfaceFoamScale("Scale", range(0, 5)) = 0.5
		_SurfaceFoamShore("Shoreline", range(0, 10)) = 2
        _SurfaceFoamSpeed ("Foam Speed", range(0,1)) = 0.2
        // Foam distortion
        _FoamDistortionNoise ("Distortion Noise", 2D) = "white" {}
        _FoamDistortionAmount ("Distortion Amount", range(0,1)) = 0.5
        // Waves
        _WaveSpeed ("Wave Speed", float) = 5
        _WaveA ("Wave A (direction, steepness, length)", Vector) = (1, 1, 0.04, 8)
        _WaveB ("Wave B (direction, steepness, length)", Vector) = (1, 0.4, 0.03, 6)
        _WaveC ("Wave C (direction, steepness, length)", Vector) = (1, 0.2, 0.05, 5)
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        LOD 300
        // We do not want to affect the depth map with this shader
        ZWrite off
        // We would like some nice alpha blending around the shoreline
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            // Smoothstep interval parameter
            #define SMOOTHSTEP_AA 0.02

            // Input data structure
            struct appdata
            {
                float4 vertex : POSITION;
                float4 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };
            // Intermediary data structure from vertex stage to fragment stage
            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 noiseUV : TEXCOORD0;
                float2 distortionUV : TEXCOORD1;
                float4 screenPos : TEXCOORD2;   // Used for depth calculations
            };

            // Bring in the properties as variables
            fixed4 _DeepColorDay;
            fixed4 _ShallowColorDay;
			fixed4 _DeepColorNight;
			fixed4 _ShallowColorNight;
            float _Opacity;
            float _MaxDepth;
            sampler2D _SurfaceFoamNoise;
            float4 _SurfaceFoamNoise_ST;    // Required by TRANSFORM_TEX
            float _SurfaceFoamCutoff;
            float _SurfaceFoamScale;
			float _SurfaceFoamShore;
            float _SurfaceFoamSpeed;
            sampler2D _FoamDistortionNoise;
            float4 _FoamDistortionNoise_ST; // Required by TRANSFORM_TEX
            float _FoamDistortionAmount;
            float _WaveSpeed;
            float4 _WaveA;
            float4 _WaveB;
            float4 _WaveC;

            // Global shader textures and variables
            sampler2D _CameraDepthTexture;
            sampler2D _CameraNormalsTexture;
			float _TimeOfDayModifier;

            float3 GerstnerWave(float4 wave, float3 p)
            {
                // Code based on https://catlikecoding.com/unity/tutorials/flow/waves/
                
                float2 d = normalize(wave.xy);
                float k = 2 * UNITY_PI / wave.w;
				float a = wave.z / k;
				float c = sqrt(9.8 / k);
                float f = k * (dot(d, p.xz) - c * _Time.y);

                return float3(
                    d.x * (a * cos(f)),
                    a * sin(f),
                    d.y * (a * cos(f))
                );
            }

            v2f vert (appdata v)
            {
                // Output data
                v2f o;

                // UV calculations
                o.noiseUV = TRANSFORM_TEX(v.uv, _SurfaceFoamNoise);
                o.distortionUV = TRANSFORM_TEX(v.uv, _FoamDistortionNoise);

                // Make some waves
				/*
                float3 p = v.vertex.xyz;
                p += GerstnerWave(_WaveA, p);
                p += GerstnerWave(_WaveB, p);
                p += GerstnerWave(_WaveC, p);

                // Apply those waves
                v.vertex.xyz = p;
				*/

                // Clip position and screen position calculations
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.screenPos = ComputeScreenPos(o.vertex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				fixed4 shallowColor = lerp(_ShallowColorNight, _ShallowColorDay, _TimeOfDayModifier);
				fixed4 deepColor = lerp(_DeepColorNight, _DeepColorDay, _TimeOfDayModifier);	

                // Code based on https://roystan.net/articles/toon-water.html#

                // Calculate the depth and normals of the current point in the scene
                float depth = tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.screenPos)).r;
                float linearDepth = LinearEyeDepth(depth);
                float3 normal = tex2Dproj(_CameraNormalsTexture, UNITY_PROJ_COORD(i.screenPos));
                // Calculate the difference in depth between the current point and the surface of the water 
                float depthDiff = linearDepth - i.screenPos.w;
                // Create a value used to interpolate linearly between the different depth colors
                float interpolation = saturate(depthDiff/_MaxDepth);
                fixed4 waterCol = lerp(shallowColor, deepColor, interpolation);
                // Apply opacity based on non-linear depth information
                waterCol.a = lerp(_Opacity, 1, interpolation*interpolation);

                // Sample distortion for animated UV's and transform to the range -1..1 multiplied by a user parameter
                float2 distortion = (tex2D(_FoamDistortionNoise, i.distortionUV) * 2 - 1) * _FoamDistortionAmount;
                // Create animated UV's for foam noise
                float animatedU = i.noiseUV.x/_SurfaceFoamScale + _Time.y * _SurfaceFoamSpeed + distortion.x;
                float animatedV = i.noiseUV.y/_SurfaceFoamScale + _Time.y * _SurfaceFoamSpeed + distortion.y;
                float2 animatedNoiseUV = float2(animatedU, animatedV);
                // Surface foam effect from sampled noise texture
                float surfaceFoam = tex2D(_SurfaceFoamNoise, animatedNoiseUV).r;
                // Shoreline foam effect
                float shorelineFoamRatio = saturate(depthDiff / _SurfaceFoamShore);
                float foamCutoff = _SurfaceFoamCutoff * shorelineFoamRatio;
                // Apply anti-aliasing threshold to the foam
                surfaceFoam = smoothstep(foamCutoff - SMOOTHSTEP_AA, foamCutoff + SMOOTHSTEP_AA, surfaceFoam);

				// Let the surface foam be less intense at night
				surfaceFoam = surfaceFoam * saturate((_TimeOfDayModifier + 0.5f));

                return waterCol + surfaceFoam;
            }
            ENDCG
        }
    }
}
