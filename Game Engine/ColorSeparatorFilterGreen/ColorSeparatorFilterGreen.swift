//
//  ColorSeparatorFilterRed.swift
//  Game Engine
//
//  Created by Hasibur Rahman on 24/5/23.
//

import UIKit
import MetalKit

class ColorSeparatorFilterGreen: BaseFilter{
    
    let vertexShaderName = "basic_vertex_shader"
    var fragmentShaderName = "textured_fragment_green"
    
    init(device: MTLDevice, imageName: String, pickedImage: UIImage) {
        super.init(device: device, imageName: imageName, vertexShaderName: self.vertexShaderName, fragmentShaderName: self.fragmentShaderName, pickedImage: pickedImage)
       
    }
}
