// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AICHEMY/VFX_Shader"
{
	Properties
	{
		[Enum(Add,1,AlphaBlend,10)]_Dst("混合模式", Float) = 10
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("剪切模式", Float) = 0
		[Enum(OFF,0,ON,1)]_CustomMainC1xy("主贴图  自定义 (C1 xy)", Float) = 0
		[Enum(R,0,A,1)]_Main_AorR("     主贴图 AorR", Float) = 0
		[HDR]_Main_Color("     主颜色", Color) = (1,1,1,1)
		_Main_Tex("     主贴图", 2D) = "white" {}
		_Main_Speed_U("     U 流动速度", Float) = 0
		_Main_Speed_V("     V 流动速度", Float) = 0
		[Toggle(_MAIN_TEX_BACK_ON)] _Main_Tex_Back("     反面开关", Float) = 0
		[HDR]_Back_Color("     反面颜色", Color) = (0,0,0,1)
		_Desaturate("     去色", Range( 0 , 1)) = 0
		[Enum(ON,0,OFF,1)]_RefineON("Refine开关", Float) = 1
		_Power("     去除强度", Float) = 1
		_HDRIntensity("     HDR强度", Float) = 1
		_SoftHDRIntensity("     Soft HDR强度", Float) = 0
		_Lerp("     混合偏移", Range( 0 , 1)) = 0.5
		[Enum(OFF,0,ON,1)]_CustomMaskC2xy("遮罩  自定义 (C2 xy)", Float) = 0
		[Enum(R,0,A,1)]_Mask_AorR("     遮罩 AorR", Float) = 0
		_Mask("     遮罩", 2D) = "white" {}
		_Mask_Speed_U("     U 流动速度", Float) = 0
		_Mask_Speed_V("     V 流动速度", Float) = 0
		_Mask_Intensity("     遮罩强度", Range( 1 , 5)) = 1
		[Enum(OFF,0,ON,1)]_CustomNoiseC1w("扭曲  自定义 (C1 w)", Float) = 0
		[Enum(R,0,A,1)]_Noise_AorR("     扭曲 AorR", Float) = 0
		_Noise("     扭曲", 2D) = "white" {}
		_Noise_Speed_U("     U 流动速度", Float) = 0
		_Noise_Speed_V("     V 流动速度", Float) = 0
		[Toggle(_NOISE_TO_MASK_ON)] _Noise_to_Mask("     扭曲 是否影响 遮罩", Float) = 0
		[Toggle(_NOISE_TO_DISSOLVE_ON)] _Noise_to_Dissolve("     扭曲 是否影响 溶解", Float) = 1
		_Noise_Intensity("     扭曲强度", Range( 0 , 1)) = 0
		[Enum(OFF,0,ON,1)]_CustomDissolveC1z("溶解  自定义 (C1 z)", Float) = 0
		[Enum(OFF,0,ON,1)]_Dissolve_Soft("     软溶解开关", Float) = 0
		[Enum(R,0,A,1)]_Dissolve_AorR("     溶解 AorR", Float) = 0
		[HDR]_Dissolve_Color("     溶解颜色", Color) = (1,1,1,1)
		_Dissolve("     溶解", 2D) = "white" {}
		_Dissolve_U("     U 流动速度", Float) = 0
		_Dissolve_V("     V 流动速度", Float) = 0
		_Dissolve_Intensity("     溶解强度", Range( 0 , 1)) = 0
		_Dissolve_Edge("     溶解边缘", Range( 0 , 1)) = 0.02
		_Dissolve_SoftEdge("     软溶解边缘", Range( 1 , 10)) = 5
		[Enum(OFF,0,ON,1)]_Fresnel("菲尼尔开关", Float) = 0
		[Toggle(_FRESNEL_REVERSE_ON)] _Fresnel_Reverse("     反向菲尼尔", Float) = 0
		_Fresnel_Bias("     菲尼尔偏移", Range( -1 , 1)) = 0
		_Fresnel_Power("     菲尼尔强度", Range( 0 , 20)) = 5
		[Toggle(_VERTEX_OFFSET_ON)] _Vertex_Offset("顶点偏移开关", Float) = 0
		[Enum(OFF,0,ON,1)]_VertexOffset_y_ON("Y强度 自定义(C2 Z)", Float) = 0
		[Enum(R,0,A,1)]_Vertex_AorR("     顶点图 AorR", Float) = 0
		_Vertex_Tex("     顶点图", 2D) = "white" {}
		_Vertex_Speed_U("     U 顶点流动速度", Float) = 0
		_Vertex_Speed_V("     V 顶点 流动速度", Float) = 0
		_Vector_XYZW("     顶点 XYZ强度 W倍增", Vector) = (0,0.5,0,0.2)
		[Toggle(_SOFT_PARTICLE_ON)] _Soft_Particle("软粒子", Float) = 0
		_Soft_Intensity("     软粒子强度", Range( 0 , 5)) = 1
		[Enum(OFF,4,ON,8)]_ZTest("置顶显示", Float) = 4

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha [_Dst]
		AlphaToMask Off
		Cull [_CullMode]
		ColorMask RGBA
		ZWrite Off
		ZTest [_ZTest]
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_COLOR
			#pragma shader_feature_local _VERTEX_OFFSET_ON
			#pragma shader_feature_local _NOISE_TO_DISSOLVE_ON
			#pragma shader_feature_local _NOISE_TO_MASK_ON
			#pragma shader_feature_local _FRESNEL_REVERSE_ON
			#pragma shader_feature_local _SOFT_PARTICLE_ON
			#pragma shader_feature_local _MAIN_TEX_BACK_ON


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float3 ase_normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_color : COLOR;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float _Dst;
			uniform float _CullMode;
			uniform float _ZTest;
			uniform float4 _Vector_XYZW;
			uniform float _VertexOffset_y_ON;
			uniform sampler2D _Vertex_Tex;
			uniform float _Vertex_Speed_U;
			uniform float _Vertex_Speed_V;
			uniform float4 _Vertex_Tex_ST;
			uniform float _Vertex_AorR;
			uniform float4 _Main_Color;
			uniform sampler2D _Main_Tex;
			uniform float _Main_Speed_U;
			uniform float _Main_Speed_V;
			uniform float4 _Main_Tex_ST;
			uniform float _CustomMainC1xy;
			uniform sampler2D _Noise;
			uniform float _Noise_Speed_U;
			uniform float _Noise_Speed_V;
			uniform float4 _Noise_ST;
			uniform float _Noise_AorR;
			uniform float _Noise_Intensity;
			uniform float _CustomNoiseC1w;
			uniform float _Dissolve_Intensity;
			uniform float _CustomDissolveC1z;
			uniform sampler2D _Dissolve;
			uniform float _Dissolve_U;
			uniform float _Dissolve_V;
			uniform float4 _Dissolve_ST;
			uniform float _Dissolve_AorR;
			uniform float _Dissolve_Edge;
			uniform float _Dissolve_Soft;
			uniform float4 _Dissolve_Color;
			uniform float _Main_AorR;
			uniform float _Desaturate;
			uniform float _Power;
			uniform float _HDRIntensity;
			uniform float _SoftHDRIntensity;
			uniform float _Lerp;
			uniform float _RefineON;
			uniform sampler2D _Mask;
			uniform float _Mask_Speed_U;
			uniform float _Mask_Speed_V;
			uniform float4 _Mask_ST;
			uniform float _CustomMaskC2xy;
			uniform float _Mask_AorR;
			uniform float _Mask_Intensity;
			uniform float4 _Back_Color;
			uniform float _Fresnel_Bias;
			uniform float _Fresnel_Power;
			uniform float _Fresnel;
			UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
			uniform float4 _CameraDepthTexture_TexelSize;
			uniform float _Soft_Intensity;
			uniform float _Dissolve_SoftEdge;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 temp_cast_0 = (0.0).xxx;
				float lerpResult291 = lerp( _Vector_XYZW.y , v.ase_texcoord2.z , _VertexOffset_y_ON);
				float3 appendResult249 = (float3(( v.vertex.xyz.x * _Vector_XYZW.x ) , ( v.vertex.xyz.y * lerpResult291 ) , ( v.vertex.xyz.z * _Vector_XYZW.z )));
				float2 appendResult259 = (float2(_Vertex_Speed_U , _Vertex_Speed_V));
				float2 uv_Vertex_Tex = v.ase_texcoord.xy * _Vertex_Tex_ST.xy + _Vertex_Tex_ST.zw;
				float2 panner260 = ( 1.0 * _Time.y * appendResult259 + uv_Vertex_Tex);
				float4 tex2DNode263 = tex2Dlod( _Vertex_Tex, float4( panner260, 0, 0.0) );
				float lerpResult265 = lerp( tex2DNode263.r , tex2DNode263.a , _Vertex_AorR);
				#ifdef _VERTEX_OFFSET_ON
				float3 staticSwitch250 = ( appendResult249 * lerpResult265 * _Vector_XYZW.w );
				#else
				float3 staticSwitch250 = temp_cast_0;
				#endif
				
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord4.xyz = ase_worldNormal;
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord5 = screenPos;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_texcoord2 = v.ase_texcoord1;
				o.ase_color = v.color;
				o.ase_texcoord3 = v.ase_texcoord2;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				o.ase_texcoord4.w = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = staticSwitch250;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i , half ase_vface : VFACE) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 appendResult23 = (float2(_Main_Speed_U , _Main_Speed_V));
				float2 uv_Main_Tex = i.ase_texcoord1.xy * _Main_Tex_ST.xy + _Main_Tex_ST.zw;
				float2 panner22 = ( 1.0 * _Time.y * appendResult23 + uv_Main_Tex);
				float2 appendResult159 = (float2(i.ase_texcoord2.x , i.ase_texcoord2.y));
				float2 lerpResult158 = lerp( panner22 , ( uv_Main_Tex + appendResult159 ) , _CustomMainC1xy);
				float2 appendResult47 = (float2(_Noise_Speed_U , _Noise_Speed_V));
				float2 uv_Noise = i.ase_texcoord1.xy * _Noise_ST.xy + _Noise_ST.zw;
				float2 panner49 = ( 1.0 * _Time.y * appendResult47 + uv_Noise);
				float4 tex2DNode50 = tex2D( _Noise, panner49 );
				float lerpResult53 = lerp( tex2DNode50.r , tex2DNode50.a , _Noise_AorR);
				float2 temp_cast_0 = (lerpResult53).xx;
				float lerpResult187 = lerp( _Noise_Intensity , i.ase_texcoord2.w , _CustomNoiseC1w);
				float2 lerpResult54 = lerp( lerpResult158 , temp_cast_0 , lerpResult187);
				float4 tex2DNode1 = tex2D( _Main_Tex, lerpResult54 );
				float lerpResult162 = lerp( _Dissolve_Intensity , i.ase_texcoord2.z , _CustomDissolveC1z);
				float temp_output_114_0 = ( 1.05 * lerpResult162 );
				float2 appendResult128 = (float2(_Dissolve_U , _Dissolve_V));
				float2 uv_Dissolve = i.ase_texcoord1.xy * _Dissolve_ST.xy + _Dissolve_ST.zw;
				float2 panner130 = ( 1.0 * _Time.y * appendResult128 + uv_Dissolve);
				float2 temp_cast_1 = (lerpResult53).xx;
				#ifdef _NOISE_TO_DISSOLVE_ON
				float staticSwitch132 = lerpResult187;
				#else
				float staticSwitch132 = 0.0;
				#endif
				float2 lerpResult131 = lerp( panner130 , temp_cast_1 , staticSwitch132);
				float4 tex2DNode89 = tex2D( _Dissolve, lerpResult131 );
				float lerpResult91 = lerp( tex2DNode89.r , tex2DNode89.a , _Dissolve_AorR);
				float lerpResult141 = lerp( _Dissolve_Edge , 0.0 , _Dissolve_Soft);
				float temp_output_101_0 = step( temp_output_114_0 , ( lerpResult91 + lerpResult141 ) );
				float temp_output_116_0 = ( temp_output_101_0 - step( temp_output_114_0 , lerpResult91 ) );
				float lerpResult31 = lerp( tex2DNode1.r , tex2DNode1.a , _Main_AorR);
				float4 lerpResult122 = lerp( tex2DNode1 , ( temp_output_116_0 * _Dissolve_Color * lerpResult31 ) , temp_output_116_0);
				float3 desaturateInitialColor75 = (lerpResult122).rgb;
				float desaturateDot75 = dot( desaturateInitialColor75, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar75 = lerp( desaturateInitialColor75, desaturateDot75.xxx, _Desaturate );
				float3 temp_cast_2 = (_Power).xxx;
				float3 lerpResult282 = lerp( ( pow( desaturateVar75 , temp_cast_2 ) * _HDRIntensity ) , ( desaturateVar75 * _SoftHDRIntensity ) , _Lerp);
				float3 lerpResult283 = lerp( lerpResult282 , desaturateVar75 , _RefineON);
				float2 appendResult37 = (float2(_Mask_Speed_U , _Mask_Speed_V));
				float2 uv_Mask = i.ase_texcoord1.xy * _Mask_ST.xy + _Mask_ST.zw;
				float2 panner38 = ( 1.0 * _Time.y * appendResult37 + uv_Mask);
				float2 appendResult164 = (float2(i.ase_texcoord3.x , i.ase_texcoord3.y));
				float2 lerpResult166 = lerp( panner38 , ( uv_Mask + appendResult164 ) , _CustomMaskC2xy);
				float2 temp_cast_3 = (lerpResult53).xx;
				#ifdef _NOISE_TO_MASK_ON
				float staticSwitch73 = lerpResult187;
				#else
				float staticSwitch73 = 0.0;
				#endif
				float2 lerpResult72 = lerp( lerpResult166 , temp_cast_3 , staticSwitch73);
				float4 tex2DNode39 = tex2D( _Mask, lerpResult72 );
				float lerpResult41 = lerp( tex2DNode39.r , tex2DNode39.a , _Mask_AorR);
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = i.ase_texcoord4.xyz;
				#ifdef _FRESNEL_REVERSE_ON
				float staticSwitch234 = abs( _Fresnel_Bias );
				#else
				float staticSwitch234 = _Fresnel_Bias;
				#endif
				#ifdef _FRESNEL_REVERSE_ON
				float staticSwitch230 = -1.0;
				#else
				float staticSwitch230 = 1.0;
				#endif
				float fresnelNdotV216 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode216 = ( staticSwitch234 + staticSwitch230 * pow( 1.0 - fresnelNdotV216, _Fresnel_Power ) );
				float lerpResult219 = lerp( 1.0 , saturate( fresnelNode216 ) , _Fresnel);
				float4 appendResult30 = (float4(( lerpResult283 * (i.ase_color).rgb ) , ( _Main_Color.a * lerpResult31 * ( lerpResult41 * _Mask_Intensity ) * _Back_Color.a * lerpResult219 * i.ase_color.a )));
				float4 screenPos = i.ase_texcoord5;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth82 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
				float distanceDepth82 = abs( ( screenDepth82 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _Soft_Intensity ) );
				#ifdef _SOFT_PARTICLE_ON
				float staticSwitch86 = saturate( distanceDepth82 );
				#else
				float staticSwitch86 = 1.0;
				#endif
				float lerpResult139 = lerp( ( lerpResult31 * temp_output_101_0 ) , saturate( ( ( lerpResult91 + 1.0 + ( lerpResult162 * -2.0 ) ) * _Dissolve_SoftEdge ) ) , _Dissolve_Soft);
				float4 temp_output_27_0 = ( _Main_Color * appendResult30 * staticSwitch86 * lerpResult139 );
				#ifdef _MAIN_TEX_BACK_ON
				float4 staticSwitch210 = ( _Back_Color * staticSwitch86 * lerpResult139 * appendResult30 );
				#else
				float4 staticSwitch210 = temp_output_27_0;
				#endif
				float4 switchResult209 = (((ase_vface>0)?(temp_output_27_0):(staticSwitch210)));
				
				
				finalColor = switchResult209;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
324;88;2560;1349;2408.471;146.7592;1.710234;True;True
Node;AmplifyShaderEditor.CommentaryNode;59;-4403.992,428.7175;Inherit;False;1649.516;414.7015;Noise;9;55;45;46;48;47;49;50;51;53;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-4353.993,643.1191;Inherit;False;Property;_Noise_Speed_U;     U 流动速度;25;0;Create;False;0;1;Option1;1;1;;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-4353.293,727.4195;Inherit;False;Property;_Noise_Speed_V;     V 流动速度;26;0;Create;False;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;201;-5261.114,331.8829;Inherit;False;747.8606;607.6332;CustomData;8;161;159;156;174;175;253;254;255;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;48;-4315.319,498.3985;Inherit;False;0;50;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;47;-4130.979,648.8168;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;147;-4387.542,1343.607;Inherit;False;3494.43;936.5343;Dissolve;33;127;126;129;128;130;131;92;143;89;103;141;115;95;91;114;102;101;100;118;94;116;96;119;93;106;99;105;97;139;123;138;132;162;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;174;-5211.114,531.9752;Inherit;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;55;-3134.187,542.4349;Inherit;False;Property;_Noise_Intensity;     扭曲强度;29;0;Create;False;0;2;Option1;0;Option2;1;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;49;-3994.936,505.1084;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;126;-4337.542,1808.08;Inherit;False;Property;_Dissolve_V;     V 流动速度;36;0;Create;False;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;127;-4333.042,1723.78;Inherit;False;Property;_Dissolve_U;     U 流动速度;35;0;Create;False;0;1;Option1;1;1;;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;253;-4678.987,687.0634;Inherit;False;Property;_CustomNoiseC1w;扭曲  自定义 (C1 w);22;1;[Enum];Create;False;0;2;OFF;0;ON;1;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;187;-2843.388,550.6661;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;200;-3336.464,-90.16143;Inherit;False;1723.859;465.5802;Main_Tex;13;13;12;23;11;22;54;1;32;31;122;29;158;76;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-3529.973,678.3211;Inherit;False;Property;_Noise_AorR;     扭曲 AorR;23;1;[Enum];Create;False;0;2;R;0;A;1;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;128;-4110.027,1729.478;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;50;-3703.379,478.7175;Inherit;True;Property;_Noise;     扭曲;24;0;Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;129;-4246.396,1588.703;Inherit;False;0;89;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;130;-3939.734,1595.573;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-3285.763,257.0396;Inherit;False;Property;_Main_Speed_V;     V 流动速度;7;0;Create;False;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-3285.335,172.7398;Inherit;False;Property;_Main_Speed_U;     U 流动速度;6;0;Create;False;0;1;Option1;1;1;;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;132;-3473.566,1393.737;Inherit;False;Property;_Noise_to_Dissolve;     扭曲 是否影响 溶解;28;0;Create;False;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;53;-3302.785,507.8205;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-3206.216,28.01994;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;23;-3063.449,178.4374;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;131;-3708.849,1598.211;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;159;-4897.98,405.883;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;161;-4675.964,567.7866;Inherit;False;Property;_CustomMainC1xy;主贴图  自定义 (C1 xy);2;1;[Enum];Create;False;0;2;OFF;0;ON;1;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;89;-3496.537,1573.558;Inherit;True;Property;_Dissolve;     溶解;34;0;Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;143;-3227.966,2156.186;Inherit;False;Constant;_0;0;29;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;255;-4681.874,865.2241;Inherit;False;Property;_CustomDissolveC1z;溶解  自定义 (C1 z);30;1;[Enum];Create;False;0;2;OFF;0;ON;1;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;22;-2890.149,35.53744;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;92;-3387.16,1778.006;Inherit;False;Property;_Dissolve_AorR;     溶解 AorR;32;1;[Enum];Create;False;0;2;R;0;A;1;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;156;-4714.878,378.3694;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;138;-1561.117,1870.33;Inherit;False;Property;_Dissolve_Soft;     软溶解开关;31;1;[Enum];Create;False;0;2;OFF;0;ON;1;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;103;-3262.188,1937.728;Inherit;False;Property;_Dissolve_Edge;     溶解边缘;38;0;Create;False;0;0;0;False;0;False;0.02;0.02;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-4237.431,2043.328;Inherit;False;Property;_Dissolve_Intensity;     溶解强度;37;0;Create;False;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;162;-3790.303,2048.328;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;141;-2970.795,1943.253;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;115;-3584.92,1898.495;Inherit;False;Constant;_105;1.05;24;0;Create;True;0;0;0;False;0;False;1.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;91;-3023.629,1604.006;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;158;-2673.941,-40.16144;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;102;-2837.978,1777.939;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;54;-2490.286,40.87046;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-3430.198,1905.443;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-2319.409,16.53891;Inherit;True;Property;_Main_Tex;     主贴图;5;0;Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;32;-2186.126,256.9488;Inherit;False;Property;_Main_AorR;     主贴图 AorR;3;1;[Enum];Create;False;0;2;R;0;A;1;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;101;-2701.761,1614.803;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;100;-2712.309,1424.261;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;31;-1841.478,216.4187;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;116;-2297.633,1400.494;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;118;-2092.115,1565.136;Inherit;False;Property;_Dissolve_Color;     溶解颜色;33;1;[HDR];Create;False;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;77;-3411.203,876.2875;Inherit;False;1558.835;414.0927;Mask;12;35;34;37;36;38;72;39;40;41;43;44;166;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-3361.203,1174.38;Inherit;False;Property;_Mask_Speed_V;     V 流动速度;20;0;Create;False;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-3356.704,1090.08;Inherit;False;Property;_Mask_Speed_U;     U 流动速度;19;0;Create;False;0;1;Option1;1;1;;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;175;-5209.788,732.5161;Inherit;False;2;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;119;-1829.964,1402.633;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;122;-2001.796,24.46154;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;37;-3151.49,1095.778;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;36;-3276.454,947.0082;Inherit;False;0;39;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;237;-1751.93,833.3693;Inherit;False;1418.111;445.5233;Fresnel;11;231;232;235;225;234;230;216;226;236;219;223;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;164;-3936.29,1156.513;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;287;-2113.58,-1358.992;Inherit;False;1076.496;555.4966;Refine;10;276;274;277;278;279;275;284;282;283;290;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;223;-1701.93,883.7155;Inherit;False;Property;_Fresnel_Bias;     菲尼尔偏移;42;0;Create;False;0;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;254;-4681.987,775.3144;Inherit;False;Property;_CustomMaskC2xy;遮罩  自定义 (C2 xy);16;1;[Enum];Create;False;0;2;OFF;0;ON;1;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-1865.532,114.5897;Inherit;False;Property;_Desaturate;     去色;10;0;Create;False;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;165;-3773.062,1135.186;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;29;-1835.605,18.06474;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PannerNode;38;-2992.449,955.4958;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;276;-2063.58,-1285.284;Inherit;False;Property;_Power;     去除强度;12;0;Create;False;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;73;-2621.441,520.4537;Inherit;False;Property;_Noise_to_Mask;     扭曲 是否影响 遮罩;27;0;Create;False;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;231;-1534.101,985.3693;Inherit;False;Constant;_Fresnel1;Fresnel1;39;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;166;-2845.601,1102.611;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;232;-1538.101,1062.369;Inherit;False;Constant;_Fresnel2;Fresnel2;39;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;75;-1578.849,22.08045;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.AbsOpNode;235;-1395.101,954.3693;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;234;-1240.101,883.3693;Inherit;False;Property;_Fresnel_Reverse;Fresnel_Reverse;41;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;230;True;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;278;-1765.527,-1085.454;Inherit;False;Property;_SoftHDRIntensity;     Soft HDR强度;14;0;Create;False;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;72;-2697.228,953.4682;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;230;-1245.101,989.3693;Inherit;False;Property;_Fresnel_Reverse;     反向菲尼尔;41;0;Create;False;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;274;-1838.907,-1302.219;Inherit;False;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;225;-1252.345,1120.595;Inherit;False;Property;_Fresnel_Power;     菲尼尔强度;43;0;Create;False;0;0;0;False;0;False;5;5;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;94;-2912.129,2143.502;Inherit;False;Constant;_2;-2;22;0;Create;True;0;0;0;False;0;False;-2;-2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;277;-1929.229,-1176.902;Inherit;False;Property;_HDRIntensity;     HDR强度;13;0;Create;False;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;93;-2495.729,1913.145;Inherit;False;Constant;_1;1;22;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;290;-1558.39,-1133.755;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;275;-1604.082,-1308.992;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FresnelNode;216;-966.1403,923.4735;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;-2721.995,2059.752;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;288;-162.3677,297.0907;Inherit;False;1899.408;825.6282;Vertex Offset;17;257;256;259;258;241;239;260;245;263;247;264;246;265;249;268;291;293;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;39;-2549.413,927.6557;Inherit;True;Property;_Mask;     遮罩;18;0;Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;279;-1693.272,-996.2645;Inherit;False;Property;_Lerp;     混合偏移;15;0;Create;False;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;88;-2046.268,453.3703;Inherit;False;1012.457;310.478;Soft_Particle;5;85;82;84;87;86;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-2428.806,1132.111;Inherit;False;Property;_Mask_AorR;     遮罩 AorR;17;1;[Enum];Create;False;0;2;R;0;A;1;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;257;-112.3677,920.04;Inherit;False;Property;_Vertex_Speed_U;     U 顶点流动速度;48;0;Create;False;0;1;Option1;1;1;;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;236;-661.4958,1057.898;Inherit;False;Property;_Fresnel;菲尼尔开关;40;1;[Enum];Create;False;0;2;OFF;0;ON;1;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;256;-111.6665,1004.34;Inherit;False;Property;_Vertex_Speed_V;     V 顶点 流动速度;49;0;Create;False;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-2190.368,1132.722;Inherit;False;Property;_Mask_Intensity;     遮罩强度;21;0;Create;False;0;0;0;False;0;False;1;1;1;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;99;-2295.139,1758.443;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;106;-2388.897,2164.141;Inherit;False;Property;_Dissolve_SoftEdge;     软溶解边缘;39;0;Create;False;0;0;0;False;0;False;5;5;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;282;-1405.366,-1206.257;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;85;-1996.268,647.8483;Inherit;False;Property;_Soft_Intensity;     软粒子强度;52;0;Create;False;0;0;0;False;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;81;-2250.78,-700.6126;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;284;-1459.557,-919.495;Inherit;False;Property;_RefineON;Refine开关;11;1;[Enum];Create;False;0;2;ON;0;OFF;1;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;41;-2199.208,1005.611;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;226;-661.3785,923.8322;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;241;14.97162,469.861;Inherit;False;Property;_Vector_XYZW;     顶点 XYZ强度 W倍增;50;0;Create;False;0;0;0;False;0;False;0,0.5,0,0.2;1,1,1,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;25;-2280.53,-497.613;Inherit;False;Property;_Main_Color;     主颜色;4;1;[HDR];Create;False;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-2014.37,1004.722;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;82;-1687.97,627.5483;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;283;-1219.084,-1094.487;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;259;110.6475,925.7375;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;-2123.698,1893.743;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;285;-2057.402,-706.5481;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;258;-32.11963,776.9684;Inherit;False;0;263;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;293;403.0948,708.5777;Inherit;False;Property;_VertexOffset_y_ON;Y强度 自定义(C2 Z);45;1;[Enum];Create;False;0;2;OFF;0;ON;1;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;208;-2283.02,-308.8985;Inherit;False;Property;_Back_Color;     反面颜色;9;1;[HDR];Create;False;0;0;0;False;0;False;0,0,0,1;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;219;-495.4973,900.2952;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;97;-1709.891,1768.516;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;260;283.9475,782.8376;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;123;-1553.252,1401.395;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;286;-1155.348,-58.51403;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-1460.2,191.0664;Inherit;True;6;6;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;291;738.3073,546.0673;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;239;868.6597,415.2751;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;84;-1431.57,627.5483;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-1464.712,503.3703;Inherit;False;Constant;_Float0;Float 0;18;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;246;1124.701,439.5906;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;264;987.9705,1004.249;Inherit;False;Property;_Vertex_AorR;     顶点图 AorR;46;1;[Enum];Create;False;0;2;R;0;A;1;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;86;-1291.812,598.2698;Inherit;False;Property;_Soft_Particle;软粒子;51;0;Create;False;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;30;-967.9332,18.82649;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;245;1124.501,347.0907;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;139;-1158.112,1393.607;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;247;1125.602,531.9907;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;263;854.6875,763.2598;Inherit;True;Property;_Vertex_Tex;     顶点图;47;0;Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;249;1285.401,347.991;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;265;1332.618,963.7189;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-661.0483,-2.215739;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;205;-633.5135,239.6044;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;251;-202.8529,145.3304;Inherit;False;Constant;_Vertex0;Vertex0;41;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;268;1575.04,699.9554;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;210;-441.5168,114.1592;Inherit;False;Property;_Main_Tex_Back;     反面开关;8;0;Create;False;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SwitchByFaceNode;209;-230.7232,-0.7908487;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;252;-2537.655,-320.0696;Inherit;False;Property;_ZTest;置顶显示;53;1;[Enum];Create;False;0;2;OFF;4;ON;8;0;True;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;214;-2740.618,-327.6642;Inherit;False;Property;_Dst;混合模式;0;1;[Enum];Create;False;0;2;Add;1;AlphaBlend;10;0;True;0;False;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;202;-2537.928,-401.6737;Inherit;False;Property;_CullMode;剪切模式;1;1;[Enum];Create;False;0;1;Option1;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;250;-79.35343,132.3302;Inherit;False;Property;_Vertex_Offset;顶点偏移开关;44;0;Create;False;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;2,-1;Float;False;True;-1;2;ASEMaterialInspector;100;1;AICHEMY/VFX_Shader;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;1;5;False;-1;10;True;214;0;1;False;-1;1;False;-1;True;0;False;213;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;2;True;202;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;True;2;False;-1;True;3;True;252;True;True;0;False;-1;0;False;-1;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;47;0;46;0
WireConnection;47;1;45;0
WireConnection;49;0;48;0
WireConnection;49;2;47;0
WireConnection;187;0;55;0
WireConnection;187;1;174;4
WireConnection;187;2;253;0
WireConnection;128;0;127;0
WireConnection;128;1;126;0
WireConnection;50;1;49;0
WireConnection;130;0;129;0
WireConnection;130;2;128;0
WireConnection;132;0;187;0
WireConnection;53;0;50;1
WireConnection;53;1;50;4
WireConnection;53;2;51;0
WireConnection;23;0;12;0
WireConnection;23;1;13;0
WireConnection;131;0;130;0
WireConnection;131;1;53;0
WireConnection;131;2;132;0
WireConnection;159;0;174;1
WireConnection;159;1;174;2
WireConnection;89;1;131;0
WireConnection;22;0;11;0
WireConnection;22;2;23;0
WireConnection;156;0;11;0
WireConnection;156;1;159;0
WireConnection;162;0;95;0
WireConnection;162;1;174;3
WireConnection;162;2;255;0
WireConnection;141;0;103;0
WireConnection;141;1;143;0
WireConnection;141;2;138;0
WireConnection;91;0;89;1
WireConnection;91;1;89;4
WireConnection;91;2;92;0
WireConnection;158;0;22;0
WireConnection;158;1;156;0
WireConnection;158;2;161;0
WireConnection;102;0;91;0
WireConnection;102;1;141;0
WireConnection;54;0;158;0
WireConnection;54;1;53;0
WireConnection;54;2;187;0
WireConnection;114;0;115;0
WireConnection;114;1;162;0
WireConnection;1;1;54;0
WireConnection;101;0;114;0
WireConnection;101;1;102;0
WireConnection;100;0;114;0
WireConnection;100;1;91;0
WireConnection;31;0;1;1
WireConnection;31;1;1;4
WireConnection;31;2;32;0
WireConnection;116;0;101;0
WireConnection;116;1;100;0
WireConnection;119;0;116;0
WireConnection;119;1;118;0
WireConnection;119;2;31;0
WireConnection;122;0;1;0
WireConnection;122;1;119;0
WireConnection;122;2;116;0
WireConnection;37;0;34;0
WireConnection;37;1;35;0
WireConnection;164;0;175;1
WireConnection;164;1;175;2
WireConnection;165;0;36;0
WireConnection;165;1;164;0
WireConnection;29;0;122;0
WireConnection;38;0;36;0
WireConnection;38;2;37;0
WireConnection;73;0;187;0
WireConnection;166;0;38;0
WireConnection;166;1;165;0
WireConnection;166;2;254;0
WireConnection;75;0;29;0
WireConnection;75;1;76;0
WireConnection;235;0;223;0
WireConnection;234;1;223;0
WireConnection;234;0;235;0
WireConnection;72;0;166;0
WireConnection;72;1;53;0
WireConnection;72;2;73;0
WireConnection;230;1;231;0
WireConnection;230;0;232;0
WireConnection;274;0;75;0
WireConnection;274;1;276;0
WireConnection;290;0;75;0
WireConnection;290;1;278;0
WireConnection;275;0;274;0
WireConnection;275;1;277;0
WireConnection;216;1;234;0
WireConnection;216;2;230;0
WireConnection;216;3;225;0
WireConnection;96;0;162;0
WireConnection;96;1;94;0
WireConnection;39;1;72;0
WireConnection;99;0;91;0
WireConnection;99;1;93;0
WireConnection;99;2;96;0
WireConnection;282;0;275;0
WireConnection;282;1;290;0
WireConnection;282;2;279;0
WireConnection;41;0;39;1
WireConnection;41;1;39;4
WireConnection;41;2;40;0
WireConnection;226;0;216;0
WireConnection;44;0;41;0
WireConnection;44;1;43;0
WireConnection;82;0;85;0
WireConnection;283;0;282;0
WireConnection;283;1;75;0
WireConnection;283;2;284;0
WireConnection;259;0;257;0
WireConnection;259;1;256;0
WireConnection;105;0;99;0
WireConnection;105;1;106;0
WireConnection;285;0;81;0
WireConnection;219;1;226;0
WireConnection;219;2;236;0
WireConnection;97;0;105;0
WireConnection;260;0;258;0
WireConnection;260;2;259;0
WireConnection;123;0;31;0
WireConnection;123;1;101;0
WireConnection;286;0;283;0
WireConnection;286;1;285;0
WireConnection;42;0;25;4
WireConnection;42;1;31;0
WireConnection;42;2;44;0
WireConnection;42;3;208;4
WireConnection;42;4;219;0
WireConnection;42;5;81;4
WireConnection;291;0;241;2
WireConnection;291;1;175;3
WireConnection;291;2;293;0
WireConnection;84;0;82;0
WireConnection;246;0;239;2
WireConnection;246;1;291;0
WireConnection;86;1;87;0
WireConnection;86;0;84;0
WireConnection;30;0;286;0
WireConnection;30;3;42;0
WireConnection;245;0;239;1
WireConnection;245;1;241;1
WireConnection;139;0;123;0
WireConnection;139;1;97;0
WireConnection;139;2;138;0
WireConnection;247;0;239;3
WireConnection;247;1;241;3
WireConnection;263;1;260;0
WireConnection;249;0;245;0
WireConnection;249;1;246;0
WireConnection;249;2;247;0
WireConnection;265;0;263;1
WireConnection;265;1;263;4
WireConnection;265;2;264;0
WireConnection;27;0;25;0
WireConnection;27;1;30;0
WireConnection;27;2;86;0
WireConnection;27;3;139;0
WireConnection;205;0;208;0
WireConnection;205;1;86;0
WireConnection;205;2;139;0
WireConnection;205;3;30;0
WireConnection;268;0;249;0
WireConnection;268;1;265;0
WireConnection;268;2;241;4
WireConnection;210;1;27;0
WireConnection;210;0;205;0
WireConnection;209;0;27;0
WireConnection;209;1;210;0
WireConnection;250;1;251;0
WireConnection;250;0;268;0
WireConnection;0;0;209;0
WireConnection;0;1;250;0
ASEEND*/
//CHKSM=8037BA564585919F9EA70DD4408376430E508C40