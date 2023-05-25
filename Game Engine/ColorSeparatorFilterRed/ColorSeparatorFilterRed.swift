//
//  ColorSeparatorFilterRed.swift
//  Game Engine
//
//  Created by Hasibur Rahman on 24/5/23.
//

import UIKit
import MetalKit

class ColorSeparatorFilterRed: BaseFilter{
    
    let vertexShaderName = "basic_vertex_shader"
    var fragmentShaderName = "textured_fragment_red"
    
    init(device: MTLDevice, imageName: String) {
        super.init(device: device, imageName: imageName, vertexShaderName: self.vertexShaderName, fragmentShaderName: self.fragmentShaderName)
       
    }
    
}
