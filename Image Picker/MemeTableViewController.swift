//
//  MemeTableViewController.swift
//  Image Picker
//
//  Created by Kathryn on 5/11/15.
//  Copyright (c) 2015 KSamalin. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Get ahold of some Memes for the table
    // This is an array of Meme instances
    var allMemes: [Meme]?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        // retrieve the memes stored in AppDelegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        allMemes = appDelegate.memes

    }
    
    func reloadData() {}
    
    
    // MARK: Table View Data Source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMemes!.count
    
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableRow") as! UITableViewCell
        let meme = self.allMemes?[indexPath.row]
        
        // Set the top text and image
        cell.textLabel!.text = meme!.text1! + " -- " + meme!.text2!
        cell.imageView?.image = meme?.originalImage
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
                
        // Get the new ViewController
        var controller: MemeDetailView
        controller = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetail") as! MemeDetailView
        
        // Pass the Meme to the new controller
        controller.meme = self.allMemes?[indexPath.row]
        
        // Present the view Controller
        self.navigationController!.pushViewController(controller, animated: true)
        
    }
    
}
