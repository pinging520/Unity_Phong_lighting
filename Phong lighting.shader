Shader "Custom/Phong lighting"
{
    Properties {
        _Color("color" , color) = (0,0,0,0)
    }
 
    SubShader 
    {
        Tags { "RenderType"="Qpaque" }
        LOD 200
        pass{
            CGPROGRAM
        
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float3 worldPos : TEXCOORD0;
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                float3 worldPos : TEXCOORD0;
            };

            float4 _Color;
            

            v2f vert(appdata a){
                v2f o;
                o.vertex = UnityObjectToClipPos(a.vertex);
                o.normal = a.normal;
                o.worldPos = mul(unity_ObjectToWorld,a.vertex).xyz;
                return o;
            }

            float4 frag(v2f v): SV_Target {
                //ambient
                float4 _Ambient = (1,1,1,1);
                float _AmbientStrength = 0.5;
                float4 ambient = _Ambient * _AmbientStrength;
                
                //diffuse
                float3 normalVector = v.normal;
                normalVector = normalize(normalVector);
                float3 lightSrc = _WorldSpaceLightPos0.xyz;
                
                float diff = max(0.0,dot(lightSrc,normalVector));
                float4 diffuse =float4(diff*_LightColor0.rgb,1);
                
                //specular
                float3 camera = _WorldSpaceCameraPos; 
                float3 view = normalize(camera - v.worldPos); 
                float3 h = normalize(lightSrc + view); 

                float specular = max(0,dot(h,normalVector));
                float3 spe = pow(specular,32) * _LightColor0.rgb;

                return float4(_Color*(diffuse+ambient)+spe,1);
            }
            ENDCG
        }
    }
}
