//
//  ViewController.swift
//  playground
//
//  Created by Chris Leung on 3/22/17.
//  Copyright © 2017 Chris Leung. All rights reserved.
//

import UIKit

class ViewController: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        
        print(info)
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imagePickerView.image = image
        }
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
}

