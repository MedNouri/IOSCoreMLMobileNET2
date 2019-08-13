//
//  ViewController.swift
//  ImgaeAI
//
//  Created by Mohamed  Nouri on 12/08/2019.
//  Copyright © 2019 Mohamed  Nouri. All rights reserved.
//

import UIKit
import Vision
class ViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    
    //Mark: UI elements
    
    // Button to select the ui
    let addButton : UIButton = {
        let item = UIButton()
        item.setTitle("Load image", for: .normal)
        item.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        item.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        item.translatesAutoresizingMaskIntoConstraints = false
        return item
    }()
    
    // the selected image view
    let imagePlaceholder : UIImageView = {
        let imageview = UIImageView()
        imageview.clipsToBounds = true
        imageview.contentMode = UIImageView.ContentMode.scaleAspectFit
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    // Result text Label
    let resultLable : UILabel = {
        let resultLable = UILabel()
        resultLable.textColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        resultLable.text = "Select an Image"
        resultLable.font = UIFont.boldSystemFont(ofSize: 30)
        resultLable.translatesAutoresizingMaskIntoConstraints = false
        return resultLable
    }()
    
    
    // mobileNet
    let mobilenet = MobileNetV2()
    //Mark: Image seleted
    var selectedimage:UIImage?{
        
        didSet{
            guard let image =  selectedimage else {
                return
            }
            imagePlaceholder.image = selectedimage
            resultLable.text = "Loading..."
            if let imagebuffer = convertImage(image: image) {
                
                if let predection = try? mobilenet.prediction(image: imagebuffer){
                     resultLable.text =  " \(predection.classLabel) "
                }
            }
        }
        
    }
    var  imagepicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // image Piker delegate
        imagepicker.allowsEditing = false
        imagepicker.delegate = self
        // Layout Code
        SetUpLayout()
        
        
        
        
        
        
        
    }
    @objc func selectAnImage(){
    present(imagepicker, animated: true, completion: nil)
    }
    
    
    
}

