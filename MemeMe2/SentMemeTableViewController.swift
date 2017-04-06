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
            editMemeVC.removeCancelButton = true
            self.present(editMemeVC, animated: true, completion: nil)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell")!
        let memeRow = memes[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = memeRow.topText + " " + memeRow.bottomText
        cell.imageView?.image = memeRow.memedImage
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
}
