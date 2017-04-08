//
//  ProtocolsAndExtensions.swift
//  For Meme v2.0 Project
//  Methods that are either used by multiple classes or related to those used by multiple classes -- consolidated here in order to centralize related code and eliminate duplicate code.
//
//  Created by Chris Leung on 3/30/17.
//  Copyright © 2017 Chris Leung. All rights reserved.
//

import UIKit


extension UIViewController {

    // MARK: Returns the current saved memes array
    func getMemes() -> [Meme] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }

    // MARK: Set meme label font attributes (for cells in SentMemeTableViewController and SentMemeCollectionViewController)
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
    
    // MARK: Set text field font attributes (for editable text fields in EditMemeViewController). Implemented here since it uses text attributes that are shared with other parts of the application.
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
    
    // MARK: Shared meme text attributes. These properties configure meme text in EditMemeViewController, SentMemeTableViewController, and SentMemeCollectionViewController. Font size and stroke width are passed in as arguments.
    func sharedMemeTextAttributesWith(_ fontSize:CGFloat, _ fontStrokeWidth:CGFloat) -> [String:Any] {
        return [NSStrokeColorAttributeName: UIColor.black,
                NSForegroundColorAttributeName: UIColor.white,
                NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: fontSize)!,
                NSStrokeWidthAttributeName: fontStrokeWidth]
    }
}

// MARK: Code to disable status bar in UIImagePickerControllers (Album and Camera)

extension UIImagePickerController {
    open override var childViewControllerForStatusBarHidden: UIViewController? {
        return nil
    }
    
    open override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
