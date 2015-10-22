//
//  ProfilePictureCollectionViewController.swift
//  SnapCloud
//
//  Created by LT Carbonell on 10/21/15.
//  Copyright © 2015 LT Carbonell. All rights reserved.
//

import UIKit
import Parse

private let reuseIdentifier = "profilePicCell"

class ProfilePictureCollectionViewController: UIViewController, UICollectionViewDelegate {

    var images: [UIImage] = []
    var imageObjects: [PFObject] = []
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        searchForImages()
        self.collectionView?.reloadData()
        // Register cell classes
        //self.collectionView!.registerClass(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchForImages() {
        let query = PFQuery(className:"Images")
        query.whereKey("username", equalTo: currentUser!.username! )
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
                            self.collectionView!.reloadData()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ProfileCollectionViewCell
        print(self.images[indexPath.row])
        cell.imageView.image = self.images[indexPath.row]
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath) as? ProfileCollectionViewCell
        if selectedCell != nil {
            
            let imageData = UIImagePNGRepresentation(selectedCell!.imageView.image!)
            let imageFile = PFFile(name:"image.png", data:imageData!)
            
            let userPhoto = PFObject(className:"UserPhoto")
            userPhoto["imageName"] = currentUser!.username
            userPhoto["imageFile"] = imageFile
            userPhoto.saveInBackgroundWithBlock{
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                    print("Added Photo \(selectedCell!.imageView.image)")
                    let alert = UIAlertController(title: "Photo Changed", message: "Your profile picture has successfully been changed.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                } else {
                    // There was a problem, check error.description
                    let alert = UIAlertController(title: "Error", message: error?.description, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
