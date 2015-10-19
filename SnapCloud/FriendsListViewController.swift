//
//  NewFriendsViewController.swift
//  SnapCloud
//
//  Created by LT Carbonell on 10/14/15.
//  Copyright © 2015 LT Carbonell. All rights reserved.
//

import UIKit
import Parse

class FriendsListViewController: UIViewController {

    @IBOutlet var friendsListTableView: UITableView!
    
    var friendsList: [PFObject]?
    var usersList: [PFUser]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        searchForUsers()
        searchForFriends()
        
        friendsListTableView.allowsSelection = true
        
    }
    
    func searchForUsers() {
        let query = PFUser.query()
        query!.whereKey("username", notEqualTo: currentUser!.username!)
        do {
            usersList = try query!.findObjects() as? [PFUser]
        } catch {
            let alert = UIAlertController(title: "Error", message: "Unable to search, please try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    func searchForFriends() {
        let query = PFQuery(className: "Friends")
        query.whereKey("user", equalTo: (currentUser?.username)!)
        do {
            friendsList = try query.findObjects()
        } catch {
            print("error")
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if usersList != nil {
            return (usersList?.count)!
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friendListCell", forIndexPath: indexPath) as! UserTableViewCell
        
        // Configure the cell...
        let user = usersList![indexPath.row]
        
        cell.username.text = user.username
        cell.fullname.text = user["name"] as? String
        cell.imageView?.image = user["profilePicture"] as? UIImage
        cell.accessoryType = .None
        
        if friendsList != nil {
            for friendRelation in friendsList! {
                let friend = friendRelation["friend"] as! String
                let user = cell.username.text!
                print(friend, user)
                if friend == user {
                    cell.accessoryType = .Checkmark
                }
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as? UserTableViewCell
        if selectedCell != nil {
            if selectedCell!.accessoryType == .None {
                selectedCell!.accessoryType = .Checkmark
                
                let friendRelation = PFObject(className: "Friends")
                friendRelation["user"] = currentUser!.username
                friendRelation["friend"] = selectedCell!.username.text!
                friendRelation.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // The object has been saved.
                        print("Added Friend \(selectedCell!.username.text!)")
                        
                    } else {
                        // There was a problem, check error.description
                        let alert = UIAlertController(title: "Error", message: error?.description, preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        self.performSegueWithIdentifier("friendsListToFriends", sender: self)
    }
    
    @IBAction func doneButton(sender: AnyObject) {
        self.performSegueWithIdentifier("friendsListToFriends", sender: self)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
    //}
    

}
