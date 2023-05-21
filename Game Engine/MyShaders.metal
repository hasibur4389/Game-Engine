//
//  MyShaders.metal
//  Game Engine
//
//  Created by Hasibur Rahman on 21/5/23.
//

#include <metal_stdlib>
using namespace metal;


struct VertexIn {
    float3 position;
    float4 color;
};

struct RasterizerData {
    float4 position [[ position ]]; // this wont be interpolated among three veritces if we declare it this way, position will return that exact position
    float4 color;
};

vertex RasterizerData basic_vertex_shader(device VertexIn *vertices [[ buffer(0) ]],
                                  uint vertexID [[ vertex_id ]]){
    RasterizerData rasterizerData;
    rasterizerData.position = float4(vertices[vertexID].position, 1);
    rasterizerData.color = float4(vertices[vertexID].color);
    
    return rasterizerData;
}


fragment half4 basic_fragment_shader(RasterizerData rasterizerData [[ stage_in ]]) {
    float4 color = rasterizerData.color;
    
    return half4(color.r, color.g, color.b, color.a);
}
