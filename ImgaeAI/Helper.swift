//
//  Helper.swift
//  ImgaeAI
//
//  Created by Mohamed  Nouri on 13/08/2019.
//  Copyright © 2019 Mohamed  Nouri. All rights reserved.
//

import Foundation
import UIKit
extension ViewController{
    // set up the Layout No StoryBoard 
    
      func SetUpLayout() {
        view.backgroundColor = .black
        navigationController?.navigationBar.topItem?.title = "Classification App 🍎"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .black
        view.addSubview(addButton)
        addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addButton.layer.cornerRadius = 25
        
        
        addButton.addTarget(self, action: #selector(selectAnImage), for: .touchUpInside)
        
        view.addSubview(imagePlaceholder)
        imagePlaceholder.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imagePlaceholder.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        imagePlaceholder.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor).isActive = true
        imagePlaceholder.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        
        view.addSubview(resultLable)
        resultLable.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resultLable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
    }
    
    // convert A image to cv Pixel Buffer with 224*224
      func convertImage(image: UIImage) -> CVPixelBuffer? {
      
        let newSize = CGSize(width: 224.0, height: 224.0)
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        
        guard let resizedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        
        UIGraphicsEndImageContext()
        
        // convert to pixel buffer
        
        let attributes = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                          kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         Int(newSize.width),
                                         Int(newSize.height),
                                         kCVPixelFormatType_32ARGB,
                                         attributes,
                                         &pixelBuffer)
        
        guard let createdPixelBuffer = pixelBuffer, status == kCVReturnSuccess else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(createdPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(createdPixelBuffer)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(data: pixelData,
                                      width: Int(newSize.width),
                                      height: Int(newSize.height),
                                      bitsPerComponent: 8,
                                      bytesPerRow: CVPixelBufferGetBytesPerRow(createdPixelBuffer),
                                      space: colorSpace,
                                      bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) else {
                                        return nil
        }
        
        context.translateBy(x: 0, y: newSize.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context)
        resizedImage.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(createdPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        return createdPixelBuffer
    }
}

extension ViewController{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let seleted = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        self.selectedimage = seleted
      picker.dismiss(animated: true, completion: nil)
    }
    
    
    
}
