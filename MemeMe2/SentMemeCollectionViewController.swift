//
//  SentMemeCollectionViewController.swift
//  MemeMe2
//
//  Created by Chris Leung on 4/1/17.
//  Copyright © 2017 Chris Leung. All rights reserved.
//

import UIKit

class SentMemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    private var memes:[Meme]!

    // MARK: Properties for flow layout
    private var memeImageVerticalScreenDimensions:CGFloat!
    private var memeImageHorizontalScreenDimensions:CGFloat!
    private var memeImageSpacing:CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memeImageSpacing = 1.0
        
        flowLayout.minimumInteritemSpacing = memeImageSpacing
        flowLayout.minimumLineSpacing = memeImageSpacing
        
        if view.frame.size.height > view.frame.size.width {
            memeImageVerticalScreenDimensions = (view.frame.size.width - (memeImageSpacing*2.0)) / 3.0
            memeImageHorizontalScreenDimensions = (view.frame.size.height - (memeImageSpacing*5.0)) / 6.0
            setFlowLayoutForVerticalOrientation()
        } else {
            memeImageVerticalScreenDimensions = (view.frame.size.height - (memeImageSpacing*5.0)) / 6.0
            memeImageHorizontalScreenDimensions = (view.frame.size.width - (memeImageSpacing*2.0)) / 3.0
            setFlowLayoutForHorizontalOrientation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get the updated array of memes
        memes = getMemes()
        
        // Reload data (we may have created a new meme)
        self.collectionView?.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if size.height > size.width {
            setFlowLayoutForVerticalOrientation()
        } else {
            setFlowLayoutForHorizontalOrientation()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! SentMemeCollectionViewCell
        let meme = memes[indexPath.row]
        cell.image.image = meme.memedImage
        return cell
    }
    
    func setFlowLayoutForVerticalOrientation() {
        flowLayout.itemSize = CGSize(width: memeImageVerticalScreenDimensions, height: memeImageVerticalScreenDimensions)
    }
    
    func setFlowLayoutForHorizontalOrientation() {
        flowLayout.itemSize = CGSize(width: memeImageHorizontalScreenDimensions, height: memeImageHorizontalScreenDimensions)
    }
    
}
