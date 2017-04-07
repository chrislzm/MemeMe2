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

protocol MemeHelpers {
    func getMemes() -> [Meme]
    func setupMemeLabelandText(_ label:UILabel,_ text:String)
}

extension MemeHelpers {

    // MARK: Get memes implementation, centralized here

    func getMemes() -> [Meme] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }

    // MARK: Set meme label font attributes, centralized here
    func setupMemeLabelandText(_ label:UILabel,_ text:String) {
        
        // Setup text style
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!,
            NSStrokeWidthAttributeName: -1.5]
        
        // Set text field properties
        label.attributedText = NSAttributedString(string: text,attributes: memeTextAttributes)
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
    }
}

extension UICollectionViewController: MemeHelpers {}
extension UITableViewController: MemeHelpers {}

// MARK: Code to disable status bar in UIImagePickerControllers

extension UIImagePickerController {
    open override var childViewControllerForStatusBarHidden: UIViewController? {
        return nil
    }
    
    open override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
