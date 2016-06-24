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
    
    var post: PFObject! /*{
        didSet {
            print("set post")
            self.captionLabel.text = post["caption"] as? String
            
            self.photoView.file = post["media"] as? PFFile
            self.photoView.loadInBackground()
            
            
        }
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("detail view loaded")
        if post != nil {
            captionLabel.text = post["caption"] as? String
            
            //let keysArray = post.allKeys
            
            //print("Timestamp: \(post["createdAt"] as? String)")
            
            //timestampLabel.text = post["createdAt"] as? String
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "EE, MMM dd, yyyy, HH:mm a"
            
            let timestamp = dateFormatter.stringFromDate(post.createdAt!)
            
            timestampLabel.text = timestamp
            photoView.file = post["media"] as? PFFile
            photoView.loadInBackground()
        } else {
            captionLabel.text = "Post is nil"
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("detail view appeared")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*func loadData() {
        if post != nil {
            captionLabel.text = post["caption"] as? String
            photoView.file = post["media"] as? PFFile
            photoView.loadInBackground()
        } else {
            captionLabel.text = "Post is nil"
        }
    }*/
    
    @IBAction func closeView(sender: AnyObject) {
        let parentVC = self.parentViewController as! FeedViewController
        
        //parentVC.fadeOutDetailView()
        
        let post = parentVC.posts![1]
        captionLabel.text = post["caption"] as? String
        /*UIView.animateWithDuration(0.2, animations: {
            self.view.alpha = 0.0
            }, completion: { (success) in
                self.view.hidden = true
        })*/
        
        //self.view.removeFromSuperview()
        
        UIView.transitionWithView(parentVC.view, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { self.view.removeFromSuperview()}, completion: nil)
        
        self.removeFromParentViewController()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
