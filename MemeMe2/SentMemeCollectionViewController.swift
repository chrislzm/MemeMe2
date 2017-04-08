//
//  SentMemeCollectionViewController.swift
//  For Meme v2.0 Project
//  Implements a collection view for listing all saved memes. Allows a saved meme to be viewed in detail (by tapping on it).
//
//  Created by Chris Leung on 4/1/17.
//  Copyright © 2017 Chris Leung. All rights reserved.
//

import UIKit

class SentMemeCollectionViewController: UICollectionViewController {
    
    // MARK: Outlets
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK: Constants and properties for flow layout
    private let cellsPerRow:CGFloat = 3.0
    private let cellsPerColumn:CGFloat = 5.0
    private let cellSpacing:CGFloat = 1.0
    private var cellWidthAndHeightForVerticalOrientation:CGFloat!
    private var cellWidthAndHeightForHorizontalOrientation:CGFloat!

    // MARK: Other Properties
    private var memes:[Meme]!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Copy the updated array of memes
        memes = getMemes()
        
        // Force reload data
        self.collectionView?.reloadData()
        
        // Setup flowLayout
        flowLayout.minimumInteritemSpacing = cellSpacing
        flowLayout.minimumLineSpacing = cellSpacing

        if view.frame.size.height > view.frame.size.width {
            // If the height is greater, then the screen is oriented vertically
            cellWidthAndHeightForVerticalOrientation = (view.frame.size.width - (cellSpacing*(cellsPerRow-1))) / cellsPerRow
            cellWidthAndHeightForHorizontalOrientation = (view.frame.size.height - (cellSpacing*(cellsPerColumn-1))) / cellsPerColumn
            setFlowLayoutForVerticalOrientation()
        } else {
            // Else, the screen is oriented horizontally, and the "width" is actually the longer side
            cellWidthAndHeightForVerticalOrientation = (view.frame.size.height - (cellSpacing*(cellsPerRow-1))) / cellsPerRow
            cellWidthAndHeightForHorizontalOrientation = (view.frame.size.width - (cellSpacing*(cellsPerColumn-1))) / cellsPerColumn
            setFlowLayoutForHorizontalOrientation()
        }
    }

    // On screen rotation, updates the flowLayout
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
        cell.sentMemeImageView.image = meme.originalImage
        
        // Setup the cell's meme text appearance (e.g. font size, style)
        setupMemeLabelAttributes(cell.sentMemeTop, meme.topText)
        setupMemeLabelAttributes(cell.sentMemeBottom, meme.bottomText)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        // Grab the DetailVC from Storyboard
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "SentMemeDetailViewController") as! SentMemeDetailViewController
        
        //Populate view controller with data from the selected item
        detailController.sentMeme = memes[indexPath.row]

        // Present the view controller using navigation
        navigationController!.pushViewController(detailController, animated: true)
    }
    
    // MARK: Other methods

    func setFlowLayoutForVerticalOrientation() {
        if let _ = flowLayout {
            flowLayout.itemSize = CGSize(width: cellWidthAndHeightForVerticalOrientation, height: cellWidthAndHeightForVerticalOrientation)
        }
    }
    
    func setFlowLayoutForHorizontalOrientation() {
        if let _ = flowLayout {
            flowLayout.itemSize = CGSize(width: cellWidthAndHeightForHorizontalOrientation, height: cellWidthAndHeightForHorizontalOrientation)
        }
    }
    
}
