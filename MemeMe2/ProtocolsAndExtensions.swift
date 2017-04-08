//
//  ProtocolsAndExtensions.swift
//  For Meme v2.0 Project
//  Centralizes getMemes array access, extends UIImagePickerController to hide the status bar
//
//  Created by Chris Leung on 3/30/17.
//  Copyright © 2017 Chris Leung. All rights reserved.
//

import UIKit


// MARK: Meme helper methods used across classes

extension UIViewController {

    // MARK: Get the current memes array
    func getMemes() -> [Meme] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }

    // MARK: Set meme label font attributes
    func setupMemeLabelAttributes(_ label:UILabel,_ text:String) {
        
        // Modify parameters here and in sharedMemeTextAttributesWith method if you want to change meme font style in TableView and CollectionView
        let fontSize:CGFloat = 20
        let fontStrokeWidth:CGFloat = -1.5
        let textAlignment:NSTextAlignment = .center
        let backgroundColor:UIColor = .clear
        
        // Following code assigns parameters above
        let memeTextAttributes = sharedMemeTextAttributesWith(fontSize,fontStrokeWidth)
        label.attributedText = NSAttributedString(string: text,attributes: memeTextAttributes)
        label.textAlignment = textAlignment
        label.backgroundColor = backgroundColor
    }
    
    // MARK: Set editable meme text field attributes
    func setupMemeTextFieldAttributes(_ textField:UITextField, _ delegate:UITextFieldDelegate) {
        
        /// Modify parameters here and in sharedMemeTextAttributesWith method if you want to change meme font style in editor
        let fontSize:CGFloat = 40
        let fontStrokeWidth:CGFloat = -3.0
        let textAlignment:NSTextAlignment = .center
        let backgroundColor:UIColor = .clear
        
        // Following code assigns parameters above
        let memeTextAttributes = sharedMemeTextAttributesWith(fontSize,fontStrokeWidth)
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = textAlignment
        textField.delegate = delegate
        textField.backgroundColor = backgroundColor
    }
    
    // MARK: Shared meme text attributes. These are properties shared by  Meme Editor, TableView, and CollectionView. Font size and stroke width must be passed in as arguments.
    func sharedMemeTextAttributesWith(_ fontSize:CGFloat, _ fontStrokeWidth:CGFloat) -> [String:Any] {
        return [NSStrokeColorAttributeName: UIColor.black,
                NSForegroundColorAttributeName: UIColor.white,
                NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: fontSize)!,
                NSStrokeWidthAttributeName: fontStrokeWidth]
    }
    
    // MARK: Creates an edit meme view controller and prepares it for presentation
    func getEditMemeViewController(_ enableCancelButton:Bool) -> EditMemeViewController {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let editMemeVC = storyboard.instantiateViewController(withIdentifier: "EditMemeViewController")as! EditMemeViewController
        
        // Hide the cancel button this time since we have nowhere to cancel to
        editMemeVC.enableCancelButton = enableCancelButton
        return editMemeVC
    }
}

// MARK: Code to disable status bar in UIImagePickerControllers

extension UIImagePickerController {
    open override var childViewControllerForStatusBarHidden: UIViewController? {
        return nil
    }
    
    open override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
