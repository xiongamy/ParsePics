//
//  DetailViewController.swift
//  ParsePics
//
//  Created by Amy Xiong on 6/24/16.
//  Copyright © 2016 Amy Xiong. All rights reserved.
//

import UIKit
import ParseUI

class DetailViewController: UIViewController {


    @IBOutlet weak var photoView: PFImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    var post: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if post != nil {
            // set caption
            captionLabel.text = post["caption"] as? String
            
            // set timestamp
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "EE, M/dd/yy  h:mm a"
            let timestamp = dateFormatter.stringFromDate(post.createdAt!)
            timestampLabel.text = timestamp
            
            // set image
            photoView.file = post["media"] as? PFFile
            photoView.loadInBackground()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func closeView(sender: AnyObject) {
        //let parentVC = self.parentViewController as! FeedViewController
        
        //UIView.transitionWithView(parentVC.view, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { self.view.removeFromSuperview()}, completion: nil)
        
        //self.removeFromParentViewController()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}
