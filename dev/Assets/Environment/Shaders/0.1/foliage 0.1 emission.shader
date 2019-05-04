Shader "Marit/foliage/emission"
{
    Properties
    {
        //löv texturen
        _MainTex ("Texture", 2D) = "white" {}
        //Färg till löven
        _Color("Color", Color) = (1,1,1,1)
        //hur mycket som ska tas bort av det transparenta
        _Cutoff("Alpha Cutoff", Range(0.01,1)) = 0.5
        _BumpMap ("Normalmap", 2D) = "bump" {}
       
        //HDR:
        /*"What does [HDR] mean above the _AmbientColor property?
        This is called a property attribute. Colors normally have their RGB values set between 0 and 1;
        The [HDR] attribute specifies that this color property can have its values set beyond that. 
        While the screen cannot render colors outside the 0...1 range,
        the values can be used for certain kinds of rendering effects, like bloom or tone mapping.
        When it comes to defining colors that represent lights, I like to allow them to extend to the HDR range,
        just like any other light in Unity can."*/
        //?
        _EmissionMap("Emission Map", 2D) = "black" {}
        [HDR] _EmissionColor("Emission Color", Color) = (0,0,0,0)
    }
    SubShader
    {
    //Pass tags: https://docs.unity3d.com/Manual/SL-PassTags.html
        Tags { "RenderType"="Opaque"
                
                "Queue"="AlphaTest" 
                "IgnoreProjector"="True" 
                "RenderType"="TransparentCutout"  
                 "LightMode" = "ShadowCaster"
                  
                }
        LOD 100
      
        //"Disables culling - all faces are drawn."
        //Satt båda sidor av löv texturen renderas
        ZWrite On ZTest Less Cull Off

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
                TRANSFER_SHADOW_CASTER(o)
 
              return o;
               
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //ljus och skuggor på objektet
                float3 normal = normalize(i.worldNormal);
                float NdotL = dot(_WorldSpaceLightPos0, normal);
                //ville minska kontrasten av skuggan 
                NdotL=NdotL*0.5;
                //för ljus
                float4 light = NdotL * _LightColor0;
                //för emission, albedo är ett mått på reflektionsförmåga ish
                fixed4 albedo = tex2D(_MainTex, i.uv);
                //col är "själva bilden" väldigt ish, men det är det som en sen 
                //subtraherar med cutoff för att få bort transparansen
                float4 col = float4(albedo.rgb * light.rgb, albedo.a);
                //emission
                half4 emission = tex2D(_EmissionMap, i.uv) * _EmissionColor;
                col.rgb += emission.rgb;
                //gör satt transparansen tas bort
                clip(col.a - _Cutoff);
                return (col * _Color);
            }
            ENDCG
        }
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}