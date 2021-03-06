cbuffer TransformConstantBuffer : register(b0)
{
	float4x4 VertexModel;
	float4x4 NormalModel;
};

cbuffer ViewProjectionConstantBuffer : register(b1)
{
	float4x4 ViewProjection[2];
};

/*
cbuffer CameraConstantBuffer : register(b2)
{
	float4x4 CameraViewProjection;
};
*/

struct VertexShaderInput
{
	float3 Position : POSITION;
	float3 Normal : NORMAL;
	uint InstanceId : SV_InstanceID;
};

struct VertexShaderOutput
{
	float4 Position : SV_POSITION;
	float4 Normal : NORMAL;
	float3 WorldPosition : POSITION;
	// float2 UV : TEXCOORD;
	uint RenderTargetId : SV_RenderTargetArrayIndex;
};

VertexShaderOutput main(VertexShaderInput input)
{
	VertexShaderOutput output;
	float4 position = float4(input.Position, 1.0f);
	float4 worldPosition = mul(position, VertexModel);
	position = mul(worldPosition, ViewProjection[input.InstanceId % 2]);
	output.Position = (float4)position;
	float4 normal = float4(input.Normal, 0.0f);
	normal = mul(normal, NormalModel);
	output.Normal = (float4)normal;
	output.RenderTargetId = input.InstanceId % 2;
	output.WorldPosition = (float3)worldPosition.xyz;
	/*
	float4 cameraPosition = mul(worldPosition, CameraViewProjection);
	cameraPosition /= cameraPosition.w;
	float2 cameraUV = cameraPosition.xy;
	cameraUV = (cameraUV + 1.0f) / 2.0f;
	output.UV = (float2)cameraUV;
	*/
	return output;
}