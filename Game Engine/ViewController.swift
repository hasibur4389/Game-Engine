//
//  ViewController.swift
//  Game Engine
//
//  Created by Hasibur Rahman on 21/5/23.
//

import UIKit
import MetalKit

class ViewController: UIViewController {
    
    struct Vertex {
        var position: float3
        var color: float4
        var texure: float2
    }
    
    var metalView: MTKView {
        return view as! MTKView
    }
    override func loadView() {
        self.view = MTKView()
    }
    
    var device: MTLDevice!
    var commandQueue: MTLCommandQueue!
    var renderPipelineState: MTLRenderPipelineState!
    var vertices: [Vertex]!
    var deltaPosition: Float = 0
    var time: Float = 0
    
    var vertexBuffer: MTLBuffer!
    var texture: MTLTexture?
    
//    var vertexBuffers: [MTLBuffer] = [] // Array to store individual vertex buffers
//       var textures: [MTLTexture?] = [] // Array to store individual textures
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        metalView.device = MTLCreateSystemDefaultDevice()
        device = metalView.device
        metalView.clearColor = MTLClearColor(red: 0.34, green: 0.67, blue: 0.50, alpha: 1.0)
        
        metalView.colorPixelFormat = .bgra8Unorm
        commandQueue = device.makeCommandQueue()!
        
        if let texture = self.setTexture(device: device, imageName: "my.jpg"){
            self.texture = texture
        }
        createRenderPiplineState()
        createVertices()
       
        createBuffers()
        metalView.delegate = self
    }
    
    func update(deltaTime: Float){
        time += deltaTime
        
        deltaPosition = cos(time)
        
        print(deltaPosition)
    }
    
    func createVertices(){
//        for i in 0..<objectCount {
//                   // Create vertices for each object
//                   let objectVertices = createVerticesForObject(index: i)
//                   let vertexBuffer = device.makeBuffer(bytes: objectVertices, length: MemoryLayout<Vertex>.stride * objectVertices.count, options: [])!
//                   vertexBuffers.append(vertexBuffer)
//
//                   // Create texture for each object
//                   if let texture = setTexture(device: device, imageName: "object\(i).jpg") {
//                       textures.append(texture)
//                   } else {
//                       textures.append(nil)
//                   }
//               }
        
        vertices = [
            
            //MARK: TOP Left Most picture
            // Triangle 1
            Vertex(position: float3(-1.0, 1.0, 0), color: float4(1, 0, 0, 1), texure: float2(0,0)), // TOP Left
            Vertex(position: float3(-1, 0, 0), color: float4(0, 1, 0, 1), texure: float2(0, 1)), // Bottom Left
            Vertex(position: float3(0, 0, 0), color: float4(0, 0, 1, 1), texure: float2(1,1)), // Bottom Right
            // Triangle 2
            Vertex(position: float3(-1.0, 1.0, 0), color: float4(1, 0, 0, 1), texure: float2(0,0)),  // TOP Left
            Vertex(position: float3(0, 1, 0), color: float4(0, 1, 0, 1), texure: float2(1,0)), // TOP Right
            Vertex(position: float3(0, 0, 0), color: float4(0, 0, 1, 1), texure: float2(1, 1)), // Bottom Right
            
//            //MARK: TOP Right Most picture
//            // Triangle 1
//            Vertex(position: float3(0, 1.0, 0), color: float4(1, 0, 0, 1), texure: float2(0,0)), // TOP Left
//            Vertex(position: float3(0, 0, 0), color: float4(0, 1, 0, 1), texure: float2(0, 1)), // Bottom Left
//            Vertex(position: float3(1, 0, 0), color: float4(0, 0, 1, 1), texure: float2(1,1)), // Bottom Right
//            // Triangle 2
//            Vertex(position: float3(0, 1.0, 0), color: float4(1, 0, 0, 1), texure: float2(0,0)),  // TOP Left
//            Vertex(position: float3(1, 1, 0), color: float4(0, 1, 0, 1), texure: float2(1,0)), // TOP Right
//            Vertex(position: float3(1, 0, 0), color: float4(0, 0, 1, 1), texure: float2(1, 1)), // Bottom Right
//
//            //MARK: Bottom left Most picture
//            // Triangle 1
//            Vertex(position: float3(-1, 0, 0), color: float4(1, 0, 0, 1), texure: float2(0,0)), // TOP Left
//            Vertex(position: float3(-1, -1, 0), color: float4(0, 1, 0, 1), texure: float2(0, 1)), // Bottom Left
//            Vertex(position: float3(0, -1, 0), color: float4(0, 0, 1, 1), texure: float2(1,1)), // Bottom Right
//            // Triangle 2
//            Vertex(position: float3(-1, 0, 0), color: float4(1, 0, 0, 1), texure: float2(0,0)),  // TOP Left
//            Vertex(position: float3(0, 0, 0), color: float4(0, 1, 0, 1), texure: float2(1,0)), // TOP Right
//            Vertex(position: float3(0, -1, 0), color: float4(0, 0, 1, 1), texure: float2(1, 1)), // Bottom Right
//
//
//            //MARK: Bottom Right Most picture
//            // Triangle 1
//            Vertex(position: float3(0, 0, 0), color: float4(1, 0, 0, 1), texure: float2(0,0)), // TOP Left
//            Vertex(position: float3(0, -1, 0), color: float4(0, 1, 0, 1), texure: float2(0, 1)), // Bottom Left
//            Vertex(position: float3(1, -1, 0), color: float4(0, 0, 1, 1), texure: float2(1,1)), // Bottom Right
//            // Triangle 2
//            Vertex(position: float3(0, 0, 0), color: float4(1, 0, 0, 1), texure: float2(0,0)),  // TOP Left
//            Vertex(position: float3(1, 0, 0), color: float4(0, 1, 0, 1), texure: float2(1,0)), // TOP Right
//            Vertex(position: float3(1, -1, 0), color: float4(0, 0, 1, 1), texure: float2(1, 1)) // Bottom Right
//
            
        ]
    }
    
    func createBuffers(){
        vertexBuffer = device.makeBuffer(bytes: vertices, length: MemoryLayout<Vertex>.stride * vertices.count, options: [])
    }
    func createRenderPiplineState(){
        
        // 1. Create libraries for vertex shader and fragment shader and colorpixel attachments
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "basic_vertex_shader")
        let fragmentFunction = library?.makeFunction(name: "textured_fragment")
        
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


}






extension ViewController: MTKViewDelegate{

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
        
        // setting vertext buffer to our device space
        renderCommandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder?.setFragmentTexture(texture, index: 0)
        // gonna draw vertices in a counter clockwise making a triange
        renderCommandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        
        renderCommandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
        
    }
}



extension ViewController: Texturable {
    
}
