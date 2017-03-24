//
//  MemeV1ViewController.swift
//  For Meme v1.0 Project
//
//  Created by Chris Leung on 3/22/17.
//  Copyright © 2017 Chris Leung. All rights reserved.
//

import UIKit

// MARK: The Meme v1.0 viewcontroller

class MemeV1ViewController: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: Properties
    
    // editingBottomTextField is true when we are editing the bottom text field
    var editingBottomTextField:Bool!

    // MARK: Outlets
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var instructions: UITextView!

    // MARK: Actions for buttons
    
    @IBAction func openCamera(_ sender: Any) {
        pickAnImageFrom(UIImagePickerControllerSourceType.camera)
    }

    @IBAction func openAlbums(_ sender: Any) {
        pickAnImageFrom(UIImagePickerControllerSourceType.photoLibrary)
    }

    // Action for share button
    @IBAction func shareMeme(_ sender: Any) {
        
        let memedImage = generateMemedImage()
        
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
        activityController.completionWithItemsHandler = { (activity:UIActivityType?, completed:Bool, returnedItems:[Any]?, activityError:Error?) -> Void in
            if completed {
                self.save(memedImage)
            }
        }
    }

    // MARK: Text field delegate methods
    
    // Clears text field when we begin editing it
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    // Dismisses keyboard when we hit enter/return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Sets editingBottomTextField flag status
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // bottomTextField's tag is 1
        editingBottomTextField = textField.tag == 1
        return true
    }
    
    // MARK: Image picker delegate methods
    
    // Does nothing if cancel button tapped
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Loads the picture into the UIImageView and enables the sharing button
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imagePickerView.image = image
            shareButton.isEnabled = true
            topTextField.text = "TOP"
            bottomTextField.text = "BOTTOM"
            instructions.isHidden = true
        }
    }
    
    // MARK: ViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMemeTextField(topTextField)
        setupMemeTextField(bottomTextField)
        
        // Share button disabled until we successfully load an image
        shareButton.isEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    // Shifts frame upwards if we are editing the bottom text field
    func keyboardWillShow(_ notification:Notification) {
        if(editingBottomTextField!) {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }

    // Shifts frame back if we were editing the bottom text field
    func keyboardWillHide(_ notification:Notification) {
        if(editingBottomTextField!) {
            view.frame.origin.y = 0
        }
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // MARK: Other methods
    
    // Opens the camera or albums
    func pickAnImageFrom(_ source: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = source
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    // Sets up a text field in meme style
    func setupMemeTextField(_ textField:UITextField) {

        // Setup text style
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -3.0]
        
        // Set text field properties
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = self
        textField.backgroundColor = UIColor.clear
    }
    
    // Saves meme to a Meme object
    func save(_ memedImage:UIImage) {
        let theMeme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
    }
    
    // Generates the memed image from the current meme on the screen
    func generateMemedImage() -> UIImage {
        
        // Hide navbar and toolbars
        bottomToolBar.isHidden = true
        navigationController?.isNavigationBarHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
    
        // Show navbar and toolbar
        bottomToolBar.isHidden = false
        navigationController?.isNavigationBarHidden = false
        
        return memedImage
    }
}

