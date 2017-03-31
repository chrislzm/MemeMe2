//
//  SentMemeTableViewController.swift
//  For Meme v2.0 Project
//
//  Created by Chris Leung on 3/30/17.
//  Copyright © 2017 Chris Leung. All rights reserved.
//

import UIKit

class SentMemeTableViewController: UITableView, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let memes = appDelegate.memes
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let memes = appDelegate.memes
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell")!
        let memeRow = memes[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = memeRow.topText + " " + memeRow.bottomText
        cell.imageView?.image = memeRow.memedImage
        return cell
    }
}
