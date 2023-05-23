//
//  MyShaders.metal
//  Game Engine
//
//  Created by Hasibur Rahman on 21/5/23.
//

#include <metal_stdlib>
using namespace metal;


struct VertexIn {
    float3 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
    float2 texCoord [[ attribute(2) ]];
};

struct RasterizerData {
    float4 position [[ position ]]; // this wont be interpolated among three veritces if we declare it this way, position will return that exact position
    float4 color;
    float2 texCoord ;
};

vertex RasterizerData basic_vertex_shader(const VertexIn vertexIn [[ stage_in ]], constant float &deltaPosition [[ buffer(1) ]]){
    
    RasterizerData rasterizerData;
    rasterizerData.position = float4(vertexIn.position, 1);
   // rasterizerData.position.x += deltaPosition;
    rasterizerData.color = float4(vertexIn.color);
    rasterizerData.texCoord = vertexIn.texCoord;
    
    return rasterizerData;
}


fragment half4 basic_fragment_shader(RasterizerData rasterizerData [[ stage_in ]]) {
    float4 color = rasterizerData.color;
    
    return half4(color.r, color.g, color.b, color.a);
}


fragment half4 textured_fragment(RasterizerData rd [[ stage_in ]], texture2d<float> texture [[ texture(0) ]]){
    
    constexpr sampler defaultSampler;
    float4 color = texture.sample(defaultSampler, rd.texCoord);
    
//    if(rd.texCoord.x <= 0.5 && rd.texCoord.y <= 0.5)
//        return  half4(color.r, color.g, color.b, color.a);
//    else if(rd.texCoord.x > 0.5 && rd.texCoord.y <= 0.5)
//        return  half4(color.r);
    return half4(color.r, color.g, color.b, color.a);
    
    
    
}
