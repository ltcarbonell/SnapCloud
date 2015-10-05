//
//  SignUpViewController.swift
//  ParseStarterProject-Swift
//
//  Created by LT Carbonell on 10/2/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse


class SignUpViewController: UIViewController {

    @IBOutlet var name: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var passwordVerify: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAccount(sender: AnyObject) {
        if name.text == "" {
            print("No valid name")
        } else if email.text == "" {
            print("no valid email")
        } else if username.text == "" {
            print("no username")
        } else if password.text != passwordVerify.text && password.text == "" {
                print("no valid password")
        }
        else {
            let user = PFUser()
            user["name"] = name.text
            user.email = email.text!.lowercaseString
            user.username = username.text!.lowercaseString
            user.password = password.text
            
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    let errorString = error.userInfo["error"] as? NSString
                    // Show the errorString somewhere and let the user try again.
                    print(errorString)
                } else {
                    // Hooray! Let them use the app now.
                    PFUser.logInWithUsernameInBackground(user.username!.lowercaseString, password: user.password!)
                    currentUser = PFUser.currentUser()
                    self.performSegueWithIdentifier("signUpToProfile", sender: self)
                }
            }
        }
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
