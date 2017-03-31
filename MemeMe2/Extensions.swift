//
//  Extensions.swift
//  For Meme v2.0 Project
//  Extends UIImagePickerController in order to hide the status bar
//
//  Created by Chris Leung on 3/30/17.
//  Copyright © 2017 Chris Leung. All rights reserved.
//

import UIKit

extension UIImagePickerController {
    open override var childViewControllerForStatusBarHidden: UIViewController? {
        return nil
    }
    
    open override var prefersStatusBarHidden: Bool {
        return true
    }
}
