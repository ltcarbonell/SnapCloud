//
//  LoginViewController.swift
//  ParseStarterProject-Swift
//
//  Created by LT Carbonell on 10/2/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

var currentUser = PFUser.currentUser()

class LoginViewController: UIViewController {

    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if currentUser != nil {
            username.text = currentUser!.username
            password.text = currentUser!.password
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(sender: AnyObject) {
            // Show the signup or login screen
        if username.text != "" && password.text != "" {
            PFUser.logInWithUsernameInBackground(username.text!.lowercaseString, password:password.text!) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    // Do stuff after successful login.
                    currentUser = PFUser.currentUser()
                    self.performSegueWithIdentifier("loginToProfile", sender: self)
                } else {
                    // The login failed. Check error to see why.
                    print("Login failed. \(error)")
                }
            }
        }
        
        
    }

    
    // MARK: - Navigation

    /*// In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }*/
    

}
