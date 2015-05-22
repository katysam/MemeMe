//
//  MemeCollectionViewController.swift
//  Image Picker
//
//  Created by Kathryn on 5/12/15.
//  Copyright (c) 2015 KSamalin. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var allMemes: [Meme]!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // retrieve the memes stored in AppDelegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        allMemes = appDelegate.memes

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allMemes!.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // fill the cells with available memes
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCell", forIndexPath: indexPath) as! MemeCellViewController
        let meme = self.allMemes[indexPath.item]
        cell.imageView.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath) {
        
        // Get the new ViewController
        var controller: MemeDetailView
        controller = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetail") as! MemeDetailView
        
        // Pass the Meme to the new controller
        controller.meme = self.allMemes?[indexPath.item]
        
        // Present the view Controller
        self.navigationController!.pushViewController(controller, animated: true)
        
    }
    
}
