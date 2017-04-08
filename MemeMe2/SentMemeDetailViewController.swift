//
//  SentMemeDetailViewController.swift
//  For Meme v2.0 Project
//  Implements a detail view for viewing a saved meme. Allows the saved meme to be edited (by tapping on the edit button).
//
//  Created by Chris Leung on 4/1/17.
//  Copyright © 2017 Chris Leung. All rights reserved.
//

import UIKit

class SentMemeDetailViewController: UIViewController {
   
    // MARK: Properties
    
    var sentMeme:Meme!
    
    // MARK: Outlets
    
    @IBOutlet weak var sentMemeImageView: UIImageView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Creates edit button, which calls showEditMemeViewController() when tapped
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(showEditMemeViewController))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sentMemeImageView.image = sentMeme.memedImage
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: Other methods
     
    // Shows the EditMemeViewController with the current meme
    func showEditMemeViewController() {
        
        // Get an edit meme view controller with cancel button enabled
        let editMemeVC = getEditMemeViewController(true)
        
        // Send image and text over
        editMemeVC.memeImage = sentMeme.originalImage
        editMemeVC.memeTopText = sentMeme.topText
        editMemeVC.memeBottomText = sentMeme.bottomText

        present(editMemeVC, animated: true, completion: nil)
    }
    
    // Creates an edit meme view controller and and returns it
    func getEditMemeViewController(_ enableCancelButton:Bool) -> EditMemeViewController {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let editMemeVC = storyboard.instantiateViewController(withIdentifier: "EditMemeViewController")as! EditMemeViewController
        
        editMemeVC.enableCancelButton = enableCancelButton
        return editMemeVC
    }
}
