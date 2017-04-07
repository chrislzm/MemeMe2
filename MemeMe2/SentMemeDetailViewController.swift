//
//  SentMemeDetailViewController.swift
//  MemeMe2
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
    
    func showEditMemeViewController() {
        let emvc = getEditMemeViewController(true)
        print("About to present")
        emvc.memeTopText = sentMeme.topText
        emvc.memeBottomText = sentMeme.bottomText
        emvc.memeImage = sentMeme.originalImage
        present(emvc, animated: true, completion: nil)
        print ("Presented")
    }
}
