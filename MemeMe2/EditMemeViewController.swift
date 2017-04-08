//
//  EditMemeViewController.swift
//  Updated for Meme v2.0 Project
//
//  Created by Chris Leung on 3/22/17.
//  Copyright © 2017 Chris Leung. All rights reserved.
//

import UIKit

// MARK: The Meme v2.0 viewcontroller

class EditMemeViewController: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: Properties
    
    let defaultMemeTopText = "TOP"
    let defaultMemeBottomText = "BOTTOM"
    
    var enableCancelButton = true       // Disabled when we have no saved memes to show in the other views
    var editingBottomTextField = false  // When true, we will shift the screen up for the keyboard
    var firstTimeLoadingImage = true    // Set to false after first image is loaded, hiding instructions and enabling share button

    var memeImage:UIImage?              // Optional image that can be loaded (e.g. when editing a saved meme) instead of default behavior
    var memeTopText:String?             // Optional text that can be loaded (e.g. when editing a saved meme) instead of default behavior
    var memeBottomText:String?
    
    // MARK: Outlets
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var instructions: UITextView!

    // MARK: Actions for buttons
    
    @IBAction func openCamera(_ sender: Any) {
        pickAnImageFrom(UIImagePickerControllerSourceType.camera)
    }

    @IBAction func openAlbums(_ sender: Any) {
        pickAnImageFrom(UIImagePickerControllerSourceType.photoLibrary)
    }

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        
        let memedImage = generateMemedImage()
        
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = { (activity:UIActivityType?, completed:Bool, returnedItems:[Any]?, activityError:Error?) -> Void in
            if completed {
                self.alertSuccess(activity!)
                self.save(memedImage)
            }
        }
        present(activityController, animated: true, completion: nil)
    }

    // MARK: Text field delegate methods
    
    // Clears text field only when the default text is present
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == defaultMemeTopText || textField.text == defaultMemeBottomText {
            textField.text = ""
        }
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
    
    // Loads the picture into the UIImageView and, if it's the first time loading an image, sets up the editing environment
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            if firstTimeLoadingImage {
                firstTimeMemeEditorSetupWith(image)
            } else {
                imagePickerView.image = image
            }
        }
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup text field attributes (e.g. font face, style)
        setupMemeTextFieldAttributes(topTextField,self)
        setupMemeTextFieldAttributes(bottomTextField,self)
        
        // Share button disabled until we successfully load an image
        shareButton.isEnabled = false
        
        // Enable/disable the cancel button as has been requested
        cancelButton.isEnabled = enableCancelButton
        
        // Check if another class has requested a saved meme be loaded
        if let memeImage = memeImage {
            firstTimeMemeEditorSetupWith(memeImage)
            
            // We assume that if an image has been passed along, its top text and bottom text have been sent too
            topTextField.text = memeTopText
            bottomTextField.text = memeBottomText
        } else { // Otherwise, just assign the default text to the text fields and don't load any image
            topTextField.text = defaultMemeTopText
            bottomTextField.text = defaultMemeBottomText
        }
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: Notifications methods for shifting screen when keyboard appears
    
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
        if(editingBottomTextField) {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }

    // Shifts frame back if we were editing the bottom text field
    func keyboardWillHide(_ notification:Notification) {
        if(editingBottomTextField) {
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
    
    // Sets up the editor for the first time an image is loaded
    func firstTimeMemeEditorSetupWith(_ image:UIImage) {
        imagePickerView.image = image
        instructions.isHidden = true
        shareButton.isEnabled = true
        topTextField.isHidden = false
        bottomTextField.isHidden = false
    }
    
    // Saves meme to the saved memes array in the app delegate
    func save(_ memedImage:UIImage) {
        
        // Create meme object
        let theMeme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        
        // Add to array
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(theMeme)
    }
    
    // Displays an alert for save and copy actions, which usually don't present any confirmation message
    func alertSuccess(_ activityType:UIActivityType) {

        var activityDescription:String? = nil
        
        switch activityType {
        case UIActivityType.saveToCameraRoll:
            activityDescription = "saved"
        case UIActivityType.copyToPasteboard:
            activityDescription = "copied"
        default:
            break
        }
        
        // Show an alert if a description was assigned
        if let activity = activityDescription {
            let controller = UIAlertController()
            controller.title = "Success!"
            controller.message = "The meme was successfully \(activity)."
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { action in self.dismiss(animated: true, completion: nil)})
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        }
    }
    
    // Generates the memed image from the current meme on the screen
    func generateMemedImage() -> UIImage {
        
        // Hide toolbars
        configureToolbars(hidden: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
    
        // Show toolbars
        configureToolbars(hidden: false)
        
        return memedImage
    }
    
    // Show or hide toolbars
    func configureToolbars(hidden: Bool) {
        topToolBar.isHidden = hidden
        bottomToolBar.isHidden = hidden
    }

}

