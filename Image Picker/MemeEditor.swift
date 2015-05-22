//
//  MemeEditor.swift
//  Image Picker
//
//  Created by Kathryn on 5/14/15.
//  Copyright (c) 2015 KSamalin. All rights reserved.
//

import Foundation

import UIKit

class MemeEditor: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var memesButton: UIBarButtonItem!
    @IBOutlet weak var waterMark: UIImageView!
    
    var meme: Meme!
    var allMemes: [Meme]?

    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3
    ]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        if (meme != nil) {
            self.imagePickerView!.image = meme.originalImage
            self.topText.text = meme.text1
            self.bottomText.text = meme.text2
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.topText.delegate = self
        self.bottomText.delegate = self
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        
        if (meme == nil) {
            if imagePickerView.image == nil {
                topText.hidden = true
                bottomText.hidden = true
                shareButton.enabled = false
                waterMark.hidden = true
            }
        }
        
        if tabBarController != nil {
            tabBarController?.tabBar.hidden = true
        }
        
        // retrieve the memes stored in AppDelegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        allMemes = appDelegate.memes
        
        if (allMemes?.count != 0) {
            performSegueWithIdentifier("showMemeTable", sender: self)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    @IBAction func pickAnImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePickerView.image = image
            shareButton.enabled = true
            topText.hidden = false
            bottomText.hidden = false
            waterMark.hidden = false
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(pickAnImage: UIImagePickerController){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Clear the Default Text
    func textFieldDidBeginEditing(_ : UITextField) {
        if (topText .isFirstResponder() ) {
            if topText.text == "TOP TEXT" {
                topText.text = ""
            }
        }
        if (bottomText .isFirstResponder() ) {
            if bottomText.text == "BOTTOM TEXT" {
                bottomText.text = ""
            }
        }
        
    }
    
    // Keyboard and Cursor disappear when you press Enter
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    // Move the screen up when typing in the Bottom Text field
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomText .isFirstResponder() {
            view.frame.origin.y -= getKeyboardHeight(notification)
            topText.hidden = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomText .isFirstResponder() {
            view.frame.origin.y = 0
            topText.hidden = false
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func generateMemedImage() -> UIImage {
        
        //Hide toolbar and navbar
        self.toolBar.hidden = true
        self.navigationBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.toolBar.hidden = false
        self.navigationBar.hidden = false
        
        return memedImage
    }
    
    func save() {
        //Create the meme
        var meme = Meme( text1: topText.text, text2: bottomText.text, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        allMemes = appDelegate.memes
        
    }
    
    @IBAction func share() {
        
        //Create the meme
        save()
        let nextController = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        self.presentViewController(nextController, animated: true, completion: nil)
        
    }
    
    @IBAction func viewMemes(sender: AnyObject) {
        if (allMemes?.count != 0) {
            performSegueWithIdentifier("showMemeTable", sender: self)
        }
        else {
            let controller = UIAlertController()
            controller.title = "There are no Memes yet."
            controller.message = "Share your Memes first, then you can review them."
            
            // Dismiss the view controller after the user taps “ok”
            let okAction = UIAlertAction (title:"Ok", style: UIAlertActionStyle.Default) {
                action in self.dismissViewControllerAnimated(true, completion: nil)
            }
            controller.addAction(okAction)
            self.presentViewController(controller, animated: true, completion:nil)

        }

    }
    
    
}


