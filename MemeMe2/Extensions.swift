//
//  Extensions.swift
//  For Meme v2.0 Project
//
//  Created by Chris Leung on 3/30/17.
//  Copyright © 2017 Chris Leung. All rights reserved.
//

import UIKit

// MARK: UIViewController extension

extension UIViewController {

    // Returns the current saved memes array
    func getMemes() -> [Meme] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }

    // Sets meme label font attributes (for cells in SentMemeTableViewController and SentMemeCollectionViewController)
    func setupMemeLabelAttributes(_ label:UILabel,_ text:String) {
        
        // Modify parameters both here and in sharedMemeTextAttributesWith(_:,_:) if you want to change text style/attributes
        let fontSize:CGFloat = 20
        let fontStrokeWidth:CGFloat = -1.5
        let textAlignment:NSTextAlignment = .center
        let backgroundColor:UIColor = .clear
        
        // Assign above parameters to the label
        let memeTextAttributes = sharedMemeTextAttributesWith(fontSize,fontStrokeWidth)
        label.attributedText = NSAttributedString(string: text,attributes: memeTextAttributes)
        label.textAlignment = textAlignment
        label.backgroundColor = backgroundColor
    }
    
    // Sets text field font attributes (for editable text fields in EditMemeViewController). Implemented here since it uses text attributes that are shared with other parts of the application.
    func setupMemeTextFieldAttributes(_ textField:UITextField, _ delegate:UITextFieldDelegate) {
        
        // Modify parameters both here and in sharedMemeTextAttributesWith(_:,_:) if you want to change text style/attributes
        let fontSize:CGFloat = 40
        let fontStrokeWidth:CGFloat = -3.0
        let textAlignment:NSTextAlignment = .center
        let backgroundColor:UIColor = .clear
        
        // Assign above parameters to the text field
        let memeTextAttributes = sharedMemeTextAttributesWith(fontSize,fontStrokeWidth)
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = textAlignment
        textField.delegate = delegate
        textField.backgroundColor = backgroundColor
    }
    
    // Returns a dictionary of meme text attributes. These common properties are shared between EditMemeViewController, SentMemeTableViewController, and SentMemeCollectionViewController. Font size and stroke width are passed in as arguments.
    func sharedMemeTextAttributesWith(_ fontSize:CGFloat, _ fontStrokeWidth:CGFloat) -> [String:Any] {
        return [NSStrokeColorAttributeName: UIColor.black,
                NSForegroundColorAttributeName: UIColor.white,
                NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: fontSize)!,
                NSStrokeWidthAttributeName: fontStrokeWidth]
    }
}

// MARK: UIImagePickerController extension

extension UIImagePickerController {
    
    // These two methods disable the status bar while in the album and camera views
    
    open override var childViewControllerForStatusBarHidden: UIViewController? {
        return nil
    }
    
    open override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
