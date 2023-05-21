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
    
    var vertexBuffer: MTLBuffer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        metalView.device = MTLCreateSystemDefaultDevice()
        device = metalView.device
        metalView.clearColor = MTLClearColor(red: 0.34, green: 0.67, blue: 0.50, alpha: 1.0)
        
        metalView.colorPixelFormat = .bgra8Unorm
        commandQueue = device.makeCommandQueue()!
        
        createRenderPiplineState()
        createVertices()
        createBuffers()
        metalView.delegate = self
    }
    
    func createVertices(){
        vertices = [
            Vertex(position: float3(0, 1, 0), color: float4(1, 0, 0, 1)), // TOP MIDDLE
            Vertex(position: float3(-1, -1, 0), color: float4(0, 1, 0, 1)), // Bottom Left
            Vertex(position: float3(1, -1, 0), color: float4(0, 0, 1, 1)) // Bottom Right
        ]
    }
    
    func createBuffers(){
        vertexBuffer = device.makeBuffer(bytes: vertices, length: MemoryLayout<Vertex>.stride * vertices.count, options: [])
    }
    func createRenderPiplineState(){
        
        // 1. Create libraries for vertex shader and fragment shader and colorpixel attachments
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "basic_vertex_shader")
        let fragmentFunction = library?.makeFunction(name: "basic_fragment_shader")
        
        // 2. create a render pipelineDescriptor
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        
        // 3. Attach pixelFormat , vertexFunc and fragmentFunc
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        
        // create a renderPipelineState and assign descriptor to it
        do{
            renderPipelineState = try device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        }catch let error as NSError{
            print("erro is \(error)")
        }
        
    }


}







extension ViewController: MTKViewDelegate {
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
        renderCommandEncoder?.setRenderPipelineState(renderPipelineState)
        
        // send data to commandEncoder
        
        // setting vertext buffer to our device space
        renderCommandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        // gonna draw vertices in a counter clockwise making a triange
        renderCommandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        
        renderCommandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
        
    }
}



