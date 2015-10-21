//
//  FriendTableViewController.swift
//  SnapCloud
//
//  Created by LT Carbonell on 10/12/15.
//  Copyright © 2015 LT Carbonell. All rights reserved.
//

import UIKit
import Parse

class FriendViewController: UIViewController {
    
    
    @IBOutlet var friendTableView: UITableView!
    
    var friendsList: [PFObject]?
    var selectedFriend: PFUser?
    var selectedUsername: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        searchForFriends()
    }

    func searchForFriends() {
        let query = PFQuery(className: "Friends")
        query.whereKey("user", equalTo: (currentUser?.username)!)
        do {
            friendsList = try query.findObjects()
        } catch {
            let alert = UIAlertController(title: "Error", message: "Unable to search users. Try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if friendsList != nil {
            return (friendsList?.count)!
        }
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath)

        // Configure the cell...
        let friend = friendsList![indexPath.row]
        
        cell.textLabel?.text = friend["friend"] as? String
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let selectedFriendObject = friendsList![indexPath.row]
        let friendCell = tableView.cellForRowAtIndexPath(indexPath)
        selectedUsername = friendCell!.textLabel!.text
        print(selectedUsername)
        selectedFriend = selectedFriendObject["friend"] as? PFUser
        
        let query = PFUser.query()
        query!.whereKey("username", equalTo: selectedUsername!)
        do {
            selectedFriend = try query!.getFirstObject() as? PFUser
            print("Found")
            performSegueWithIdentifier("viewFriendProfile", sender: self)
        } catch {
            print("error")
            let alert = UIAlertController(title: "Error", message: "Unable to load. Try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }

    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "viewFriendProfile" {
            let destination = segue.destinationViewController as! ProfileViewController
            // Pass the selected object to the new view controller.
            destination.isFriendProfile = true
            destination.profileCurrentlyOpen = selectedFriend
        }
    }

}
