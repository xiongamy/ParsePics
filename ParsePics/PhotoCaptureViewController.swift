//
//  PhotoCaptureViewController.swift
//  ParsePics
//
//  Created by Amy Xiong on 6/20/16.
//  Copyright © 2016 Amy Xiong. All rights reserved.
//

import UIKit

class PhotoCaptureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var cameraLabel: UILabel!
    @IBOutlet weak var libraryLabel: UILabel!
    @IBOutlet weak var divider: UIView!
    @IBOutlet weak var captionField: UITextField!
    @IBOutlet weak var captionView: UIView!
    //@IBOutlet weak var captionTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var captionBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var shadingView: UIView!
    
    let minScrollFraction: CGFloat = 0.2
    let maxScrollFraction: CGFloat = 0.8
    var keyboardHeight: CGFloat = 0.0
    var animationDuration: NSTimeInterval = 0.0
    
    var origBottomDistance: CGFloat = 0.0
    
    let cancelButtonAlpha: CGFloat = 0.75
    let shadingViewAlpha: CGFloat = 0.5

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelButton.layer.cornerRadius = cancelButton.frame.height / 2
        cancelButton.clipsToBounds = true
        cancelButton.hidden = true
        
        shadingView.hidden = true
        shadingView.alpha = 0.0
        
        photoView.layer.borderColor = UIColor.lightGrayColor().CGColor
        photoView.layer.borderWidth = 2
        
        captionView.layer.borderColor = UIColor.lightGrayColor().CGColor
        captionView.layer.borderWidth = 1
        
        origBottomDistance = captionBottomConstraint.constant
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapView(sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func takePhoto(sender: AnyObject) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum//Camera
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func uploadFromLibrary(sender: AnyObject) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        photoView.image = editedImage
        cameraLabel.alpha = 0
        libraryLabel.alpha = 0
        divider.alpha = 0
        cancelButton.hidden = false
        cancelButton.alpha = cancelButtonAlpha
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelPhoto(sender: AnyObject) {
        self.captionField.text = ""
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.cameraLabel.alpha = 1.0
            self.libraryLabel.alpha = 1.0
            self.divider.alpha = 1.0
            self.cancelButton.alpha = 0
            }, completion: { (success) in
                self.photoView.image = nil
                self.cancelButton.hidden = true
                
        })
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo!
        let keyboardRectangle = (userInfo.valueForKey(UIKeyboardFrameBeginUserInfoKey) as! NSValue).CGRectValue()
        let offset = (userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue).CGRectValue()
        
        self.keyboardHeight = keyboardRectangle.height
        self.animationDuration = userInfo.valueForKey(UIKeyboardAnimationDurationUserInfoKey) as! NSTimeInterval
        
        let fieldBottom = captionView.frame.maxY
        let viewBottom = self.view.frame.maxY
        let keyboardTop = viewBottom - keyboardHeight
        
        var diff = fieldBottom - keyboardTop
        
        if keyboardHeight != offset.height {
            diff = offset.height
        }
        
        if diff > 0 {
            view.layoutIfNeeded()
            UIView.animateWithDuration(animationDuration, animations: {
                self.captionBottomConstraint.constant = diff
                self.view.layoutIfNeeded()
                self.shadingView.hidden = false
                self.shadingView.alpha = self.shadingViewAlpha
                })
        }
    }
    
    func keyboardWillHide(sender: AnyObject) {
        view.layoutIfNeeded()
        UIView.animateWithDuration(animationDuration, animations: {
            self.captionBottomConstraint.constant = self.origBottomDistance
            self.view.layoutIfNeeded()
            self.shadingView.alpha = 0.0
            }, completion: { (success) in
                self.shadingView.hidden = true
        })
    }
    
    @IBAction func uploadPhoto(sender: AnyObject) {
        print("uploading...")
        let image = photoView.image
        let caption = captionField.text
        
        if image != nil {
            Post.postUserImage(image, withCaption: caption) { (success: Bool, error: NSError?) in
                if success {
                    //Dismiss the view controller
                    print("Uploaded!")
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Error", message: "There was an error while uploading your photo. Please try again.", preferredStyle: .Alert)
                    let okayAction = UIAlertAction(title: "Okay", style: .Default, handler: { (action: UIAlertAction) in
                    })
                    
                    alertController.addAction(okayAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            
            }
        } else {
            let alertController = UIAlertController(title: "No Image", message: "Please tap to take a photo or to upload an image from your photo library.", preferredStyle: .Alert)
            let okayAction = UIAlertAction(title: "Okay", style: .Default, handler: { (action: UIAlertAction) in
            })
            
            alertController.addAction(okayAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func pushCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
