//
//  ViewController.swift
//  Game Engine
//
//  Created by Hasibur Rahman on 21/5/23.
//

import UIKit
import MetalKit
import PhotosUI


class ViewController: UIViewController {
    
    
    var myFilters: [UILabel] = []
    var pickedImage: UIImage!
    var ImageName: String = "my.jpg"

  

    var device: MTLDevice!
    var colorSeparatorFilter: ColorSeparatorFilter!
    var colorSeparatorFilterRed: ColorSeparatorFilterRed!
    var colorSeparatorFilterGreen: ColorSeparatorFilterGreen!
    var colorSeparatorFilterBlue: ColorSeparatorFilterBlue!
    var colorSeparatorFilterOriginal: ColorSeparatorFilterOriginal!

    
    var metalView: MTKView {
        return view as! MTKView
    }
    
    @IBAction func saveImage(_ sender: UIButton) {
        
//        let context = CIContext()
//        let texture = (metalView.currentDrawable?.texture)!
//        print("width = \(texture.width) and height = \(texture.height)")
//        let cImg = CIImage(mtlTexture: texture, options: [:])!
//        let cgImg = context.createCGImage(cImg, from: cImg.extent)!
//        let uiImg = UIImage(cgImage: cgImg)
        
        let lastDrawableDisplayed = metalView.currentDrawable?.texture
        var uiImage: UIImage!
        if let imageRef = lastDrawableDisplayed?.toImage() {
             uiImage = UIImage.init(cgImage: imageRef)
        }
        
        // Had to put Phot and Privacy authorization in info section
        PHPhotoLibrary.requestAuthorization { status in
               if status == .authorized {
                   PHPhotoLibrary.shared().performChanges {
                       let request = PHAssetChangeRequest.creationRequestForAsset(from: uiImage)
                       // Optionally, you can specify the creation metadata for the image
                       // request.creationMetadata = ...
                   } completionHandler: { success, error in
                       if let error = error {
                           print("Error saving image to gallery: \(error.localizedDescription)")
                       } else {
                           print("Image saved to gallery successfully.")
                          
                       }
                   }
               }
           }
        
        

    }
    
    @IBAction func pickImageFromGallery(_ sender: UIButton) {
        
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        
        let phPickerVC = PHPickerViewController(configuration: config)
        phPickerVC.delegate = self
        self.present(phPickerVC, animated: true)
    }
    
    enum FiltersName: String {
        case Original = "Original"
        case Red = "Red"
        case Blue = "Blue"
        case Green = "Green"
    }
    
   
    
    

    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        metalView.device = MTLCreateSystemDefaultDevice()
        device = metalView.device
        metalView.clearColor = MTLClearColor(red: 0.34, green: 0.67, blue: 0.50, alpha: 1.0)
        
        metalView.colorPixelFormat = .bgra8Unorm
        
        // to save the image and avoid  _validateGetBytes:71: failed assertion `Get Bytes Validation
       // texture must not be a framebufferOnly texture.  result.itemProvider.loadObject(ofClass: UIImage.self) , the framebufferOnly property is set to true, indicating that the texture can only be used as a source for rendering, and it cannot be written to or modified.
        metalView.framebufferOnly = false;
        

        
        
        // Populating myLabels array
      
        myFilters.append(createLabel(label: FiltersName.Original.rawValue))
        myFilters.append(createLabel(label: FiltersName.Red.rawValue))
        myFilters.append(createLabel(label: FiltersName.Green.rawValue))
        myFilters.append(createLabel(label: FiltersName.Blue.rawValue))
        
        

        
    }
    
    // Creating a button for UICollectionView
    func createLabel(label: String) -> UILabel {
        let aLabel = UILabel()
        aLabel.text = label
        
        print("In CreateLabel \(aLabel)")
        return aLabel
        
    }
    
}

extension ViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        for result in results {
            // run on bg thread
            result.itemProvider.loadObject(ofClass: UIImage.self) {
                object, error in
                if let image = object as? UIImage{
                    self.pickedImage = image
                
                    // added sequentially action, ensure loading of picked image first then this, run on main thread
                    DispatchQueue.main.async {
                        self.colorSeparatorFilter = ColorSeparatorFilter(device: self.device, imageName: self.ImageName, pickedImage: self.pickedImage)
                                          self.metalView.delegate = self.colorSeparatorFilter
                                      }
                
                }
                else{
                    print("Error in didFinisPicking from PickerView. Image not Loaded")
                }
            }
        }
        
     
        
    }
    
    
}
    

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myFilters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCollectionViewCell
        
        cell.myLabel.text = myFilters[indexPath.item].text
        cell.myLabel.textColor = .white
        cell.myLabel.backgroundColor = .blue
        cell.myLabel.layer.cornerRadius = 10.0
    
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        // Switch to go to different features/filtered image
        let filter: String = myFilters[indexPath.item].text ?? "found nil"
        
        
    switch filter {
        case FiltersName.Original.rawValue:
        colorSeparatorFilterOriginal = ColorSeparatorFilterOriginal(device: device, imageName: ImageName, pickedImage: pickedImage)
            metalView.delegate = colorSeparatorFilterOriginal
            break
            
        case FiltersName.Red.rawValue:
        colorSeparatorFilterRed = ColorSeparatorFilterRed(device: device, imageName: ImageName, pickedImage: pickedImage)
            metalView.delegate = colorSeparatorFilterRed
            break
            
        case FiltersName.Green.rawValue:
        colorSeparatorFilterGreen = ColorSeparatorFilterGreen(device: device, imageName: ImageName, pickedImage: pickedImage)
            metalView.delegate = colorSeparatorFilterGreen
            break
            
        case FiltersName.Blue.rawValue:
        colorSeparatorFilterBlue = ColorSeparatorFilterBlue(device: device, imageName: ImageName, pickedImage: pickedImage)
            metalView.delegate = colorSeparatorFilterBlue
            break
        
        default:
        colorSeparatorFilter = ColorSeparatorFilter(device: device, imageName: ImageName, pickedImage: pickedImage)
            metalView.delegate = colorSeparatorFilter
            
            
        }
   
        
    }
    
    
    
}




 


extension MTLTexture {

    
    // Extracts raw pixel data from the current texture and store them in a buffere pointer
     func bytes() -> UnsafeMutableRawPointer {
         let width = self.width
         let height   = self.height
         let rowBytes = self.width * 4
         let p = malloc(width * height * 4)

         // MTLRegionMake2D selects the area of the texture, 0,0 means the starting position and width and height indicates how much of the whole texture to be extrated in this case the whole texture
         // mipmap , lower resolution of the texture, 0 means original resolution, 1 means first reduced texture, could be used for thumbnail etc.
         self.getBytes(p!, bytesPerRow: rowBytes, from: MTLRegionMake2D(0, 0, width, height), mipmapLevel: 0)

         return p!
     }

     func toImage() -> CGImage? {
         let p = bytes()

      //   print(type(of: p))
         // Creating a RGB color-space(range of colors tht can be displayed or rendered) to be used for CGImage
         let pColorSpace = CGColorSpaceCreateDeviceRGB()

         // These flags determine how the pixel data is interpreted and arranged in memory when creating a CGImage, ARGB id A-alpha exists, Order lest significant byte is stored first in the memory
         let rawBitmapInfo = CGImageAlphaInfo.noneSkipFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
         let bitmapInfo:CGBitmapInfo = CGBitmapInfo(rawValue: rawBitmapInfo)
         
         
          // total pixel size * 4 bytes = total memory & number of bytes per row
         let selftureSize = self.width * self.height * 4
         let rowBytes = self.width * 4
         
         
         // Creates an instance of CGDataProvider, it will use the supplied pixel data to create UIImage, , you can control the memory management of the pixel data associated with the CGImage. It allows you to manage the lifetime of the pixel data according to your specific requirements
         let releaseMaskImagePixelData: CGDataProviderReleaseDataCallback = { (info: UnsafeMutableRawPointer?, data: UnsafeRawPointer, size: Int) -> () in
             return
         }
         let provider = CGDataProvider(dataInfo: nil, data: p, size: selftureSize, releaseData: releaseMaskImagePixelData)
         
         
            // 8 & 32 are bits , bitspPerComponent 1 byTe = 8 BITS per RGBA, bitsPerPixel 4 bytes = 32 bits
         let cgImageRef = CGImage(width: self.width, height: self.height, bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: rowBytes, space: pColorSpace, bitmapInfo: bitmapInfo, provider: provider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)!

         return cgImageRef
     }
 }

//
 
 

