//
//  ViewController.swift
//  Game Engine
//
//  Created by Hasibur Rahman on 21/5/23.
//

import UIKit
import MetalKit


class ViewController: UIViewController {
    
    
    
    var metalView: MTKView {
        return view as! MTKView
    }
    override func loadView() {
        self.view = MTKView()
    }
    
    var device: MTLDevice!
    var colorSeparatorFilter: ColorSeparatorFilter!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        metalView.device = MTLCreateSystemDefaultDevice()
        device = metalView.device
        metalView.clearColor = MTLClearColor(red: 0.34, green: 0.67, blue: 0.50, alpha: 1.0)
        
        metalView.colorPixelFormat = .bgra8Unorm
        
        colorSeparatorFilter = ColorSeparatorFilter(device: device, imageName: "my.jpg")
        
        
        metalView.delegate = colorSeparatorFilter
    }
    
}
    
