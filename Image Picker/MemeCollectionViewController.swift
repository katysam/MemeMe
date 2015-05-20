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
        cell.imageView.image = meme.originalImage
        cell.topText.text = meme.text1
        cell.bottomText.text = meme.text2
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetail") as! MemeDetailView
        detailController.meme = self.allMemes?[indexPath.item]
        self.presentViewController(detailController, animated: true, completion: nil)

        
//        let memeEditor = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditor") as! MemeEditor
//        memeEditor.meme = self.allMemes?[indexPath.item]
//        self.presentViewController(memeEditor, animated: true, completion: nil)

        
    }
    
}
