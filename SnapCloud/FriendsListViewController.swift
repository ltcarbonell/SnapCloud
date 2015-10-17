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
    
    var friendsList: [PFUser]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        searchForUsers()
        
    }
    
    func searchForUsers() {
        let query = PFUser.query()
        query!.whereKey("username", notEqualTo: currentUser!.username!)
        do {
            friendsList = try query!.findObjects() as? [PFUser]
            print(friendsList)
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
        return (friendsList?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friendListCell", forIndexPath: indexPath) as! UserTableViewCell
        
        // Configure the cell...
        let user = friendsList![indexPath.row]
        
        cell.username.text = user.username
        cell.fullname.text = user["name"] as? String
        cell.imageView?.image = user["profilePicture"] as? UIImage
        
        
        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
    }
    

}
