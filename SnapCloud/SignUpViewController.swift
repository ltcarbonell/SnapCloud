//
//  SignUpViewController.swift
//  ParseStarterProject-Swift
//
//  Created by LT Carbonell on 10/2/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse


class SignUpViewController: UIViewController, UITextFieldDelegate {

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
            let alert = UIAlertController(title: "Error", message: "Enter name.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else if email.text == "" {
            let alert = UIAlertController(title: "Error", message: "Enter email address.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else if username.text == "" {
            let alert = UIAlertController(title: "Error", message: "Enter username.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else if password.text != passwordVerify.text && password.text == "" {
            let alert = UIAlertController(title: "Error", message: "Passwords Don't Match.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
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
                    // Show the errorString somewhere and let the user try again.
                    let alert = UIAlertController(title: "Error", message: error.description, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    // Hooray! Let them use the app now.
                    PFUser.logInWithUsernameInBackground(user.username!.lowercaseString, password: user.password!)
                    currentUser = PFUser.currentUser()
                    self.performSegueWithIdentifier("signUpToProfile", sender: self)
                }
            }
            
            let imageData = UIImagePNGRepresentation(UIImage(named: "DefaultProfilePic")!)
            let imageFile = PFFile(name:"image.png", data:imageData!)
            
            let userPhoto = PFObject(className:"UserPhoto")
            userPhoto["imageName"] = username.text!.lowercaseString
            userPhoto["imageFile"] = imageFile
            userPhoto.saveInBackgroundWithBlock{
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                    print("Added Photo")
                    
                } else {
                    // There was a problem, check error.description
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
