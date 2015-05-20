//
//  MemeDetailView.swift
//  MemeMe
//
//  Created by Kathryn on 5/20/15.
//  Copyright (c) 2015 KSamalin. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailView: UIViewController {
    
    @IBOutlet weak var memedImage: UIImageView!
    @IBOutlet weak var editMeme: UIButton!
    
    var meme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.memedImage!.image = meme.memedImage
    }
    
    @IBAction func editMeme(sender: AnyObject) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditor") as! MemeEditor
        detailController.meme = self.meme
        self.presentViewController(detailController, animated: true, completion: nil)

    }
}
