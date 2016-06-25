//
//  LoginViewController.swift
//  ParsePics
//
//  Created by Amy Xiong on 6/20/16.
//  Copyright © 2016 Amy Xiong. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func onLogin(sender: AnyObject) {
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        
        PFUser.logInWithUsernameInBackground(username, password: password) { (user:
            PFUser?, error: NSError?) in
            if user != nil {
                print("You're logged in!")
                self.performSegueWithIdentifier(Segues.login, sender: nil)
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    @IBAction func onSignUp(sender: AnyObject) {
        let newUser = PFUser()
        
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) in
            if success {
                print("Yay, created a user!")
                self.performSegueWithIdentifier(Segues.login, sender: nil)
            } else {
                print(error?.localizedDescription)
                
                if error?.code == 202 {
                    print("user name is taken")
                }
            }
        }
    }
}
