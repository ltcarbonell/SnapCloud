//
//  ProfileViewController.swift
//  ParseStarterProject-Swift
//
//  Created by LT Carbonell on 10/2/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse


class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var fullName: UILabel!
    @IBOutlet var username: UILabel!
    
    
    @IBOutlet var imageCollectionView: UICollectionView!
    
    var picker = UIImagePickerController()
    let profileCurrentlyOpen = currentUser
    
    var images: [UIImage] = []
    var imageObjects: [PFObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        // Do any additional setup after loading the view.
        fullName.text = profileCurrentlyOpen!["name"] as? String
        username.text = profileCurrentlyOpen!.username
        
        searchForImages()
        self.imageCollectionView.reloadData()
        
        
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
            print("nope")
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.dismissViewControllerAnimated(true, completion: {self.imageCollectionView.reloadData()})
        
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
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.allowsEditing = true
        self.presentViewController(picker, animated: true, completion: nil)
        self.imageCollectionView.reloadData()
    }
    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
        currentUser = PFUser.currentUser() // this will now be nil
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