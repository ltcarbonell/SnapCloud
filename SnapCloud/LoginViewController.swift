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
    @IBOutlet var rememberMe: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        username.text = NSUserDefaults.standardUserDefaults().stringForKey("username")
        password.text = NSUserDefaults.standardUserDefaults().stringForKey("password")
        rememberMe.setOn(NSUserDefaults.standardUserDefaults().boolForKey("rememberMe"), animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(sender: AnyObject) {
        if username.text != "" && password.text != "" {
            PFUser.logInWithUsernameInBackground(username.text!.lowercaseString, password:password.text!) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    // Do stuff after successful login.
                    currentUser = PFUser.currentUser()
                    if self.rememberMe.on {
                        NSUserDefaults.standardUserDefaults().setObject(self.username.text, forKey: "username")
                        NSUserDefaults.standardUserDefaults().setObject(self.password.text, forKey: "password")
                    } else {
                        NSUserDefaults.standardUserDefaults().removeObjectForKey("username")
                        NSUserDefaults.standardUserDefaults().removeObjectForKey("password")
                    }
                    NSUserDefaults.standardUserDefaults().setBool(self.rememberMe.on, forKey: "rememberMe")
                    self.performSegueWithIdentifier("loginToProfile", sender: self)
                } else {
                    // The login failed. Check error to see why.
                    let alert = UIAlertController(title: "Error", message: error?.description, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    // MARK: - Navigation

    /*// In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }*/
    

}
