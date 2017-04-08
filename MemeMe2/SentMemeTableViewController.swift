//
//  SentMemeTableViewController.swift
//  For Meme v2.0 Project
//
//  Created by Chris Leung on 3/30/17.
//  Copyright © 2017 Chris Leung. All rights reserved.
//

import UIKit

class SentMemeTableViewController: UITableViewController {
    
    var memes:[Meme]!

    let tableRowsPerScreen:CGFloat = 7.0
    
    override func viewDidLoad() {
        
        // Set consistent row height = screen length /tableRowsPerScreen
        if view.frame.size.height > view.frame.size.width {
            tableView.rowHeight = view.frame.size.height / tableRowsPerScreen
        } else {
            tableView.rowHeight = view.frame.size.width / tableRowsPerScreen
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Get the updated array of memes
        memes = getMemes()
        
        // Force reload data
        self.tableView.reloadData()
        
        // If we have no memes, present the Edit Meme view
        if memes.count == 0 {
            let storyboard = UIStoryboard (name: "Main", bundle: nil)
            let editMemeVC = storyboard.instantiateViewController(withIdentifier: "EditMemeViewController")as! EditMemeViewController
            
            // Hide the cancel button this time since we have nowhere to cancel to
            editMemeVC.enableCancelButton = false
            self.present(editMemeVC, animated: true, completion: nil)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell") as! SentMemeTableViewCell
        let memeRow = memes[(indexPath as NSIndexPath).row]
        cell.smallMeme.image = memeRow.originalImage
        cell.memeTop.text = memeRow.topText
        cell.memeBottom.text = memeRow.bottomText
        setupMemeLabelAttributes(cell.smallMemeTop, memeRow.topText)
        setupMemeLabelAttributes(cell.smallMemeBottom, memeRow.bottomText)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Grab the DetailVC from Storyboard
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "SentMemeDetailViewController") as! SentMemeDetailViewController
        
        //Populate view controller with data from the selected item
        detailController.sentMeme = memes[indexPath.row]
            
        // Present the view controller using navigation
        navigationController!.pushViewController(detailController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            (UIApplication.shared.delegate as! AppDelegate).memes.remove(at: indexPath.row)
            memes = getMemes()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
