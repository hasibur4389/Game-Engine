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

//
//fragment half4 basic_fragment_shader(RasterizerData rasterizerData [[ stage_in ]]) {
//    float4 color = rasterizerData.color;
//
//    return half4(color.r, color.g, color.b, color.a);
//}


// MARK: For 4 channel Picture
fragment half4 textured_fragment(RasterizerData rd [[ stage_in ]], texture2d<float> texture [[ texture(0) ]]){
    constexpr sampler defaultSampler;
    
    // Calculate the texture coordinates for each quadrant
    float2 coord = rd.texCoord;
    float2 texCoord1 = coord;
    texCoord1.x *= 2.0;
    texCoord1.y *= 2.0;
    
    float2 texCoord2 = coord;
    texCoord2.x = fmod(texCoord2.x, 0.5) * 2.0;
    texCoord2.y *= 2.0;
    
    float2 texCoord3 = coord;
    texCoord3.x *= 2.0;
    texCoord3.y = fmod(texCoord3.y, 0.5) * 2.0;
    
    float2 texCoord4 = coord;
    texCoord4.x = fmod(texCoord4.x, 0.5) * 2.0;
    texCoord4.y = fmod(texCoord4.y, 0.5) * 2.0;
    
    // Sample the textures for each quadrant
    float4 color1 = texture.sample(defaultSampler, texCoord1);
    float4 color2 = texture.sample(defaultSampler, texCoord2);
    float4 color3 = texture.sample(defaultSampler, texCoord3);
    float4 color4 = texture.sample(defaultSampler, texCoord4);
    
    // Determine the quadrant based on the texture coordinates
    half4 myColor;
    if (rd.texCoord.x < 0.5 && rd.texCoord.y < 0.5)
        myColor = half4(color1.r, color1.g, color1.b, color1.a); // quadrant = 1 top left
    else if (rd.texCoord.x >= 0.5 && rd.texCoord.y < 0.5)
        myColor = half4(color2.r,0, 0, 1); // quadrant = 2 top right
    else if (rd.texCoord.x < 0.5 && rd.texCoord.y >= 0.5)
        myColor = half4( 0, color3.g, 0, 1); // quadrant = 3 bottom left
    else
        myColor = half4(0, 0, color4.b, 1); // quadrant = 4 bottom right
    
  return myColor;
}



//MARK: for original only pic
fragment half4 textured_fragment_original(RasterizerData rd [[ stage_in ]], texture2d<float> texture [[ texture(0) ]]){
    constexpr sampler defaultSampler;
    
    // Calculate the texture coordinates for each quadrant
  
   
    
    // Sample the textures for each quadrant
    float4 color = texture.sample(defaultSampler, rd.texCoord);
    return half4(color.r, color.g, color.b, color.a);
}



//MARK: for blue pic only
fragment half4 textured_fragment_blue(RasterizerData rd [[ stage_in ]], texture2d<float> texture [[ texture(0) ]]){
    constexpr sampler defaultSampler;
    
    float4 color = texture.sample(defaultSampler, rd.texCoord);

    return half4(0, 0, color.b, color.a);
}




//MARK: for red channel pic only
fragment half4 textured_fragment_red(RasterizerData rd [[ stage_in ]], texture2d<float> texture [[ texture(0) ]]){
    constexpr sampler defaultSampler;
    
    float4 color = texture.sample(defaultSampler, rd.texCoord);
   
    return half4(color.r, 0, 0, color.a);
}



//MARK: for green channel pic only
fragment half4 textured_fragment_green(RasterizerData rd [[ stage_in ]], texture2d<float> texture [[ texture(0) ]]){
    constexpr sampler defaultSampler;

    float4 color = texture.sample(defaultSampler, rd.texCoord);
 
    return half4(0, color.g, 0, color.a);
}
