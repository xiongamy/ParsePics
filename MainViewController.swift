//
//  MainViewController.swift
//  ParsePics
//
//  Created by Amy Xiong on 6/24/16.
//  Copyright © 2016 Amy Xiong. All rights reserved.
//

import UIKit
import Parse

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func onLogout(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                let loginVC = self.storyboard!.instantiateViewControllerWithIdentifier(ViewControllers.login)
                self.presentViewController(loginVC, animated: true, completion: nil)
                
                print("Logged out!")
            }
        }
    }

}
