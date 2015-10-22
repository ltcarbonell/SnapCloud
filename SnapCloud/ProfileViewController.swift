//
//  ProfileViewController.swift
//  ParseStarterProject-Swift
//
//  Created by LT Carbonell on 10/2/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse


class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet var fullName: UILabel!
    @IBOutlet var username: UILabel!
    
    @IBOutlet var imageCollectionView: UICollectionView!
    @IBOutlet var uploadButton: UIButton!
    
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var changeProfilePictureButton: UIButton!
    
    
    var uploadPicker = UIImagePickerController()
    var profileCurrentlyOpen = currentUser
    
    var images: [UIImage] = []
    var imageObjects: [PFObject] = []
    
    var isFriendProfile = false
    var friendUsername: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePicture.layer.borderWidth = 1.0
        profilePicture.layer.masksToBounds = false
        profilePicture.layer.borderColor = UIColor.whiteColor().CGColor
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width/2
        profilePicture.clipsToBounds = true
        
        uploadPicker.delegate = self
        
        // Do any additional setup after loading the view.
        fullName.text = profileCurrentlyOpen!["name"] as? String
        username.text = profileCurrentlyOpen!.username
        
        searchForProfilePicture()
        searchForImages()
    
        if isFriendProfile {
            uploadButton.hidden = true
            changeProfilePictureButton.hidden = true
        }
    }
    
    func searchForProfilePicture() {
        let profileQuery = PFQuery(className: "UserPhoto")
        profileQuery.whereKey("imageName", equalTo: profileCurrentlyOpen!.username!)
        do {
            let imageObject = try profileQuery.findObjects() as [PFObject]
            let imageObjectLast = imageObject.last
            let imageFile = imageObjectLast!["imageFile"] as! PFFile
            var imageData: NSData
            
            do {
                imageData = try imageFile.getData()
                self.profilePicture.image = UIImage(data: imageData)
            } catch {
                let alert = UIAlertController(title: "Error", message: "Unable to grab photos. Check network connection.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        } catch {
            let alert = UIAlertController(title: "Error", message: "Unable to grab photos. Check network connection.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func searchForImages() {
        let query = PFQuery(className:"Images")
        query.whereKey("username", equalTo: profileCurrentlyOpen!.username! )
        do {
            try imageObjects = query.findObjects() as [PFObject]
            for imageObject in imageObjects {
                let imageFile = imageObject["image"] as! PFFile
                imageFile.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            let image = UIImage(data:imageData)
                            self.images.append(image!)
                            self.imageCollectionView.reloadData()
                        }
                    }
                }
            }
        } catch {
            let alert = UIAlertController(title: "Error", message: "Unable to grab photos. Check network connection.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(uploadPicker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        let imageData = UIImagePNGRepresentation(image)
        let imageFile = PFFile(name: currentUser!.username! + ".png", data:imageData!)
        
        let userPhoto = PFObject(className:"Images")
        userPhoto["username"] = currentUser!.username
        userPhoto["image"] = imageFile
        userPhoto.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                print("PhotoAdded")
                self.images = []
                self.searchForImages()
            } else {
                // There was a problem, check error.description
                let alert = UIAlertController(title: "Error", message: error?.description, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCellWithReuseIdentifier("imageCell", forIndexPath: indexPath) as! CollectionViewCell
        cell.imageView.image = self.images[indexPath.row]
        return cell
    }
    
    @IBAction func uploadPicture(sender: AnyObject) {
        uploadPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        uploadPicker.allowsEditing = true
        self.presentViewController(uploadPicker, animated: true, completion: nil)
    }
    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
        currentUser = PFUser.currentUser() // this will now be nil
        NSUserDefaults.standardUserDefaults().removeObjectForKey("username")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("password")
        self.performSegueWithIdentifier("profileToLogin", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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