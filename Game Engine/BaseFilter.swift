//
//  BaseFilter.swift
//  Game Engine
//
//  Created by Hasibur Rahman on 25/5/23.
//

import UIKit
import MetalKit

class BaseFilter: NSObject {
    
    typealias float2 = SIMD2<Float>
    typealias float3 = SIMD3<Float>
    typealias float4 = SIMD4<Float>
    
    
    struct Vertex {
        var position: float3
        var color: float4
        var texture: float2
    }
    
    var device: MTLDevice!
    var commandQueue: MTLCommandQueue!
    var renderPipelineState: MTLRenderPipelineState!
 

//    var deltaPosition: Float = 0
//    var time: Float = 0
   

    
    var vertices: [Vertex]!
    var texture: MTLTexture?
    var vertexBuffer: MTLBuffer!
    
    init(device: MTLDevice, imageName: String, vertexShaderName: String, fragmentShaderName: String) {
        super.init()
        self.device = device
        commandQueue = device.makeCommandQueue()!

        if let texture = self.setTexture(device: device, imageName: imageName){
            self.texture = texture
        }

        createRenderPiplineState(vertexShaderName: vertexShaderName, fragmentShaderName: fragmentShaderName)
        createVertices()
        createBuffers()
    }
    
    
    func createVertices(){

    
       vertices = [
        // Triangle 1
        Vertex(position: float3(-1.0, 1.0, 0), color: float4(1, 0, 0, 1), texture: float2(0,0)), // TOP Left
        Vertex(position: float3(-1, -0.65, 0), color: float4(0, 1, 0, 1), texture: float2(0, 1)), // Bottom Left
        Vertex(position: float3(1, -0.65, 0), color: float4(0, 0, 1, 1), texture: float2(1,1)), // Bottom Right
        // Triangle 2
        Vertex(position: float3(-1.0, 1.0, 0), color: float4(1, 0, 0, 1), texture: float2(0,0)),  // TOP Left
        Vertex(position: float3(1, 1, 0), color: float4(0, 1, 0, 1), texture: float2(1,0)), // TOP Right
        Vertex(position: float3(1, -0.65, 0), color: float4(0, 0, 1, 1), texture: float2(1, 1))
        ]// Bottom

    }
//
        
    func createBuffers(){
        vertexBuffer = device.makeBuffer(bytes: vertices, length: MemoryLayout<Vertex>.stride * vertices.count, options: [])
    }
        
    func createRenderPiplineState(vertexShaderName: String, fragmentShaderName: String){

        // 1. Create libraries for vertex shader and fragment shader and colorpixel attachments
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: vertexShaderName)
        let fragmentFunction = library?.makeFunction(name: fragmentShaderName)

        // 2. create a render pipelineDescriptor
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        let vertexDescriptor = MTLVertexDescriptor()

         // position
          // type of data
        vertexDescriptor.attributes[0].format = .float3
          // at which buffer we are allocationg this vertex
        vertexDescriptor.attributes[0].bufferIndex = 0
           // is it the first offset if not add the formats here
        vertexDescriptor.attributes[0].offset = 0
        // color
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].bufferIndex = 0
        vertexDescriptor.attributes[1].offset = MemoryLayout<float3>.stride

        // texture
        vertexDescriptor.attributes[2].format = .float2
        vertexDescriptor.attributes[2].bufferIndex = 0
        vertexDescriptor.attributes[2].offset = MemoryLayout<float3>.stride + MemoryLayout<float4>.stride

        // What type (Vertex) memory for layout 0 where our three 1st attributes are located
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride

        // 3. Attach pixelFormat , vertexFunc and fragmentFunc
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        renderPipelineDescriptor.vertexDescriptor = vertexDescriptor

        // create a renderPipelineState and assign descriptor to it
        do{
            renderPipelineState = try device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        }catch let error as NSError{
            print("erro is \(error)")
        }

    }
    
    func valuePass(encoder: MTLRenderCommandEncoder) {
        // do nothing. to be overridden
    }


}





extension BaseFilter: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    
    
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let renderPassDescriptor = view.currentRenderPassDescriptor
        else {
            print("Found nil")
            return
        }
        
        // RenderPassDescriptor is needed to initialize our commandEncoder as it has more information about pixel, bufferstorage information for our view for the next drawable
        let commandBuffer = commandQueue.makeCommandBuffer()
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        // To see the triangles drawn
        // renderCommandEncoder?.setTriangleFillMode(.lines)
        
        //  update(deltaTime: 1 / Float(view.preferredFramesPerSecond))
        
        
        renderCommandEncoder?.setRenderPipelineState(renderPipelineState)
        // must be before draw primitives, if we are passing simple constants we dont need to use MTLBuffer we can just use this and catch this in shader
        //renderCommandEncoder?.setVertexBytes(&deltaPosition, length: MemoryLayout<Float>.stride, index: 1)
        
        // send data to commandEncoder
        
        
        
        //setting vertext buffer to our device space
        renderCommandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder?.setFragmentTexture(texture, index: 0)
        
        
        valuePass(encoder: renderCommandEncoder!)
        // gonna draw vertices in a counter clockwise making a triange
        renderCommandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        
        renderCommandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
        
        
       
    }
    
    
}




extension BaseFilter: Texturable {
   
    
    
}

