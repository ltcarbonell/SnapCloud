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
    var usersProfilePic: [String: UIImage] = [:]
    var selectedFriend: PFUser?
    
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
        if usersList != nil  {
            for user in usersList! {
                let profileQuery = PFQuery(className: "UserPhoto")
                profileQuery.whereKey("imageName", equalTo: user.username!)
                do {
                    let imageObject = try profileQuery.findObjects() as [PFObject]
                    let imageObjectLast = imageObject.last
                    let imageFile = imageObjectLast!["imageFile"] as! PFFile
                    imageFile.getDataInBackgroundWithBlock {
                        (imageData: NSData?, error: NSError?) -> Void in
                        if error == nil {
                            if let imageData = imageData {
                                self.usersProfilePic[user.username!] = UIImage(data: imageData)
                            }
                        }
                    }
                } catch {
                    let alert = UIAlertController(title: "Error", message: "Unable to grab photos. Check network connection.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
            self.friendsListTableView.reloadData()
        }
        
        
        
    }
    
    func searchForFriends() {
        let query = PFQuery(className: "Friends")
        query.whereKey("user", equalTo: (currentUser?.username)!)
        do {
            friendsList = try query.findObjects()
        } catch {
            let alert = UIAlertController(title: "Error", message: "Unable to grab friends. Check network connection.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
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
        
        if usersProfilePic[user.username!] != nil {
            cell.profileImage.image = usersProfilePic[user.username!]! as UIImage
        } else {
            cell.profileImage.image = UIImage(named: "DefaultProfilePic")
        }
        
        
        cell.accessoryType = .None
        
        if friendsList != nil {
            for friendRelation in friendsList! {
                let friend = friendRelation["friend"] as! String
                let user = cell.username.text!
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
        
        let alert = UIAlertController(title: "Added Friend", message: "Successfully added \(selectedCell!.fullname.text!)", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Go to page.", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
        let query = PFUser.query()
        query!.whereKey("username", equalTo: selectedCell!.username.text!)
        do {
            selectedFriend = try query!.getFirstObject() as? PFUser
            print("Found")
            performSegueWithIdentifier("friendListToFriendProfile", sender: self)
        } catch {
            print("error")
            let alert = UIAlertController(title: "Error", message: "Unable to load. Try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
         //Get the new view controller using segue.destinationViewController.
        if segue.identifier == "friendListToFriendProfile" {
            let destination = segue.destinationViewController as! ProfileViewController
            // Pass the selected object to the new view controller.
            destination.isFriendProfile = true
            destination.profileCurrentlyOpen = selectedFriend
        }
        
    }
    

}
