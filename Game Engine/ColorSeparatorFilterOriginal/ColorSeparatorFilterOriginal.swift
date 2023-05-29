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
    
    init(device: MTLDevice, imageName: String, pickedImage: UIImage) {
        super.init(device: device, imageName: imageName, vertexShaderName: self.vertexShaderName, fragmentShaderName: self.fragmentShaderName, pickedImage: pickedImage)
       
    }
    
 
    
    
}







    
    
    
