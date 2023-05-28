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
        
        guard let textureImage = colorSeparatorFilterBlue.textureImage else {
                print("Texture image is nil.")
                return
            }

        print("width = \(textureImage.width) and heigh = \(textureImage.height)" )
    //print(textureImage)
        let ciImage = CIImage(mtlTexture: textureImage, options: [:])
         let ciContext = CIContext()
            
        guard let cgImage = ciContext.createCGImage(ciImage!, from: ciImage!.extent) else {
                print("Failed to convert texture image to UIImage.")
                return
            }
            
            let uiImage = UIImage(cgImage: cgImage)
            
            guard let imageData = uiImage.pngData() else {
                print("Failed to convert UIImage to PNG data.")
                return
            }
        
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
        
        
//        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            print("Failed to access documents directory.")
//            return
//        }
//
//        // Create the Documents directory if it doesn't exist
//        do {
//            try FileManager.default.createDirectory(at: documentsDirectory, withIntermediateDirectories: true, attributes: nil)
//        } catch {
//            print("Failed to create documents directory: \(error.localizedDescription)")
//            return
//        }
        
        
        
        
            
//            guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
//                print("Failed to access documents directory.")
//                return
//            }
//
//            let fileURL = documentsDirectory.appendingPathComponent("textureImage.png")
//
//            do {
//                try imageData.write(to: fileURL)
//                print("Texture image saved successfully.")
//            } catch {
//                print("Error saving texture image: \(error.localizedDescription)")
//            }
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
            result.itemProvider.loadObject(ofClass: UIImage.self) {
                object, error in
                if let image = object as? UIImage{
                    self.pickedImage = image
                
                    // added sequentially action, ensure loading of picked image first then this
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
        
        
        // default texture
        
    
        
        
        
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
