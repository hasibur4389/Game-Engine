//
//  ColorSeparatorFilterRed.swift
//  Game Engine
//
//  Created by Hasibur Rahman on 24/5/23.
//

import UIKit
import MetalKit

class ColorSeparatorFilterBlue: BaseFilter{
    
    let vertexShaderName = "basic_vertex_shader"
    var fragmentShaderName = "textured_fragment_blue"
    var textureImage: MTLTexture!
    
    var brightness = 0
    
    init(device: MTLDevice, imageName: String, pickedImage: UIImage) {
        super.init(device: device, imageName: imageName, vertexShaderName: self.vertexShaderName, fragmentShaderName: self.fragmentShaderName, pickedImage: pickedImage)
       
    }
    
    override func valuePass(encoder: MTLRenderCommandEncoder) {
       // encoder.setFragmentBytes(<#T##bytes: UnsafeRawPointer##UnsafeRawPointer#>, length: <#T##Int#>, index: <#T##Int#>)
    }
 
}
