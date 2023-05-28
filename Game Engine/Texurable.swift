//
//  Texurable.swift
//  Game Engine
//
//  Created by Hasibur Rahman on 23/5/23.
//

import MetalKit

import MetalKit

protocol Texturable {
    var texture: MTLTexture? { get set }
}

extension Texturable {
    func setTexture(device: MTLDevice, imageName: String, pickedImage: UIImage!) -> MTLTexture? {
        print("In setTexure")
        let textureLoader = MTKTextureLoader(device: device)
        var texture: MTLTexture!
        
        if let pickedImage = pickedImage {
        
            do{
                texture = try textureLoader.newTexture(cgImage: pickedImage.cgImage!, options: [:])
            }
            catch{
                print("Couldn't texture image \(error)")
            }
        }
        else{
            print("didn't get Picked Image")
            do{
                //let path = Bundle.main.path(forResource: imageName, ofType: nil)
                //let textureURL = URL(fileURLWithPath: path!)
                let textureURL = Bundle.main.url(forResource: imageName, withExtension: nil)
                
                texture = try textureLoader.newTexture(URL: textureURL!, options: [:])
            }
            catch{
                print("error thrown in texture \(error)")
            }
        }
        print("\(texture.width) AND \(texture.height)")
        return texture
        
    }
}
