//
//  ColorSeparatorFilterOriginal.swift
//  Game Engine
//
//  Created by Hasibur Rahman on 25/5/23.
//






import UIKit
import MetalKit

class ColorSeparatorFilterOriginal: BaseFilter{
    
    let vertexShaderName = "basic_vertex_shader"
    var fragmentShaderName = "textured_fragment_original"
    var textureImage: MTLTexture!
    var brightnessLevel: Float = 0.5
    
    init(device: MTLDevice, imageName: String, pickedImage: UIImage) {
        
       super.init(device: device, imageName: imageName, vertexShaderName: self.vertexShaderName, fragmentShaderName: self.fragmentShaderName, pickedImage: pickedImage)
        
  
       
    }
    
    override func valuePass(encoder: MTLRenderCommandEncoder) {
        
      //  encoder?.setVertexBytes(&deltaPosition, length: MemoryLayout<Float>.stride, index: 1)
        encoder.setFragmentBytes(&brightnessLevel, length: MemoryLayout<Float>.stride, index: 0)
    }
    
 
    
    
}







    
    
    
