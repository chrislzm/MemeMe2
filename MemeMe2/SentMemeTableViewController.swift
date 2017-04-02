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
        // Get the updated array of memes
        memes = getMemes()
        
        // Reload data (we may have created a new meme)
        self.tableView.reloadData()
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
}
