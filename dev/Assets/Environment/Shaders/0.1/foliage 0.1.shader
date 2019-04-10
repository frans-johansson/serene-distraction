Shader "Marit/foliage"
{
    Properties
    {
        //löv texturen
        _MainTex ("Texture", 2D) = "white" {}
        //Färg till löven
        _Color("Color", Color) = (1,1,1,1)
        //hur mycket som ska tas bort av det transparenta
        _Cutoff("Alpha Cutoff", Range(0.01,1)) = 0.5
    
     
    }
    SubShader
    {
    //Pass tags: https://docs.unity3d.com/Manual/SL-PassTags.html
        Tags { "RenderType"="Opaque"
                "LightMode" = "ForwardBase"
                "Queue"="AlphaTest" 
                "IgnoreProjector"="True" 
                "RenderType"="TransparentCutout"    
                }
        LOD 100
      
        //"Disables culling - all faces are drawn."
        //Satt båda sidor av löv texturen renderas
        Cull Off

        Pass
        {
            CGPROGRAM
            //för att detta är en vertex,fragment shader
            #pragma vertex vert
            #pragma fragment frag
            
            //typ inkluderar olika bibliotek
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
           
            
            //deklarationer
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 uv : TEXCOORD0;
              
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float3 worldNormal : NORMAL;
                float4 vertex : SV_POSITION;
            };
            
            //matchande deklarationer till properties
            sampler2D _MainTex;
            fixed4 _Color; // färg består av fyra komponenter: r,g,b,a därför en vektor med fyra komponenter
                           // fixed är variabeln med lägsta precision
            fixed _Cutoff; //bara ett tal
            fixed4 _AmbientColor;
            sampler2D _EmissionMap;
            fixed4 _EmissionColor;
            float4 _MainTex_ST;
            
            //funktioner
            //vertex funktionen jobbar med det geomitrsiak typ, inte färg och sånt, ish
            v2f vert (appdata v)
            {
                v2f o;
                
                 /*Transforms a point from object space to the cameras
                 clip space in homogeneous coordinates. This is the equivalent of mul(UNITY_MATRIX_MVP,
                 float4(pos, 1.0)), and should be used in its place.*/
                o.vertex = UnityObjectToClipPos(v.vertex);
                // Transforms 2D UV by scale/bias property
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                /*the normals in appdata are populated automatically, while values in v2f 
                must be manually populated in the vertex shader. As well, we want to transform 
                the normal from object space to world space, as the light's direction is provided
                 in world space. Add the following line to the vertex shader.*/
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
         
                return o;
               
            }

            fixed4 frag (v2f i) : SV_Target
            {
            
               
               
                fixed4 col = tex2D(_MainTex, i.uv);
            
                //gör satt transparansen tas bort
                clip(col.a - _Cutoff);
                return (col * _Color);
            }
            ENDCG
        }
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}
