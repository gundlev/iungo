//
//  ProfileEditVC.swift
//  iungo
//
//  Created by Niklas Gundlev on 10/09/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
//

import UIKit
import Firebase

class ProfileEditVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var firstIndexPath = NSIndexPath()
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var user: User?
    var imagePicker = UIImagePickerController()
    var indexpaths = [NSIndexPath]()
    @IBOutlet weak var tableview: MyTableView!
    
    @IBAction func fortryd(sender: AnyObject) {
        performSegueWithIdentifier("finishEditingProfile", sender: self)
    }
    
    @IBAction func gem(sender: AnyObject) {
        
        print("number of items in the array: " + String(indexpaths.count))
        var index = 3
        if indexpaths.count < 4 {
            index = 2
        }
        let url = "https://brilliant-torch-4963.firebaseio.com/users/" + (user?.userId)!
        print("This is the url: " + url)
        let ref = Firebase(url: url)
        var emailHasBeenChanged = false
        for i in 0...index {
            print("This is the index: " + String(i))
            switch i {
            case 0:
                let cell = tableview.cellForRowAtIndexPath(indexpaths[i]) as! ProfileEditUserCell
                if user?.name != cell.name.text {
                    print("name was changed")
                    ref.childByAppendingPath("name").setValue(cell.name.text!)
                    userDefaults.setObject(cell.name.text, forKey: "name")
                }
                if user?.company != cell.company.text {
                    print("company was changed")
                    ref.childByAppendingPath("company").setValue(cell.company.text)
                    userDefaults.setObject(cell.company.text, forKey: "company")
                }
                if user?.userTitle != cell.title.text {
                    print("title was changed")
                    ref.childByAppendingPath("title").setValue(cell.title.text)
                    userDefaults.setObject(cell.title.text, forKey: "title")
                }
                if user?.profileImage != cell.profileImage.image! {
                    print("image was changed")
                    let imageData = UIImageJPEGRepresentation(cell.profileImage.image!, CGFloat(0.1))
                    let base64String = imageData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
                    ref.childByAppendingPath("picture").setValue(base64String)
                    userDefaults.setObject(base64String, forKey: "picture")
//                    print(base64String)
//                    print("\n\n\n\n\n\n\n")
                }
            case 1:
                let cell = tableview.cellForRowAtIndexPath(indexpaths[i]) as! ProfileEditContactCell
                if user?.mobilNo != cell.mobilNo.text! {
                    print("mobilNo was changed")
                    ref.childByAppendingPath("mobilNo").setValue(cell.mobilNo.text!)
                    userDefaults.setObject(cell.mobilNo.text, forKey: "mobilNo")
                }
                if user?.phoneNo != cell.phoneNo.text! {
                    print("phoneNo was changed")
                    ref.childByAppendingPath("phoneNo").setValue(cell.phoneNo.text!)
                    userDefaults.setObject(cell.phoneNo.text, forKey: "phoneNo")
                }
                if user?.email != cell.email.text! {
                    print("email was changed")
                    ref.childByAppendingPath("email").setValue(cell.email.text!)
                    userDefaults.setObject(cell.email.text, forKey: "email")
                    emailHasBeenChanged = true
                }
                if user?.website != cell.website.text! {
                    print("website was changed")
                    ref.childByAppendingPath("website").setValue(cell.website.text!)
                    userDefaults.setObject(cell.website.text, forKey: "website")
                }
            case 2:
                let cell = tableview.cellForRowAtIndexPath(indexpaths[i]) as! ProfileEditAddressCell
                if user?.address != cell.address.text! {
                    print("address was changed")
                    ref.childByAppendingPath("address").setValue(cell.address.text!)
                    userDefaults.setObject(cell.address.text, forKey: "address")
                }
            case 3:
                let cell = tableview.cellForRowAtIndexPath(indexpaths[i]) as! ProfileEditDescriptionCell
                if user?.userDescription != cell.userDescription.text! {
                    print("description was changed")
                    ref.childByAppendingPath("description").setValue(cell.userDescription.text!)
                    userDefaults.setObject(cell.userDescription.text, forKey: "description")
                }
            default:
                print("Default was called in index: " + String(index))
            }
        }
//        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
//            
//            let json = JSON(snapshot.value)
//            print(json["picture"].stringValue)
//        })
        
//        if emailHasBeenChanged {
//            let emailAlert = UIAlertController(title: "Du har ændret din offentlige email", message: "Det ændre ikke på dine login oplysninger!", preferredStyle: .Alert)
//            emailAlert.addAction(UIAlertAction(title: "Forstået!", style: UIAlertActionStyle.Cancel, handler: nil))
//            self.presentViewController(emailAlert, animated: true, completion: nil)
//        }
        performSegueWithIdentifier("finishEditingProfile", sender: self)
    }
    
    @IBAction func changeProfileImage(sender: AnyObject) {
        let optionsMenu = UIAlertController(title: "Vælg resource", message: nil, preferredStyle: .ActionSheet)
        let cameraRoll = UIAlertAction(title: "Kamera rulle", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Camera Roll")
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
                print("Button capture")
                
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .PhotoLibrary;
                self.imagePicker.allowsEditing = true
                
                self.presentViewController(self.imagePicker, animated: true, completion: nil)
            }
        })
        let takePhoto = UIAlertAction(title: "Tag billede", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Take Photo")
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
                print("Button capture")
                
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .Camera;
                self.imagePicker.allowsEditing = true
                
                self.presentViewController(self.imagePicker, animated: true, completion: nil)
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Take Photo")
        })
        
        optionsMenu.addAction(cameraRoll)
        optionsMenu.addAction(takePhoto)
        optionsMenu.addAction(cancel)
        
        self.presentViewController(optionsMenu, animated: true, completion: nil)
    }
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        print("didFinishPickingMediaWithInfo")
//        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            //imageView.contentMode = .ScaleAspectFit
//            self.user?.profileImage = pickedImage
//            self.tableview.reloadData()
//        }
//    }
    
    func imagePickerController(picker: UIImagePickerController, let didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("didFinishPickingImage")
        //var imageData = UIImagePNGRepresentation(image)
        let imageData = UIImageJPEGRepresentation(image, CGFloat(0.2))
        let base64String = imageData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        //print(base64String)
        
        let imageWidth: CGFloat = image.size.width
        
        let imageHeight: CGFloat = image.size.height
        
        var cropRect: CGRect

        if ( imageWidth < imageHeight) {
            // Potrait mode
            cropRect = CGRectMake (0.0, (imageHeight - imageWidth) / 2.0, imageWidth, imageWidth)
        } else {
            // Landscape mode
            cropRect = CGRectMake ((imageWidth - imageHeight) / 2.0, 0.0, imageHeight, imageHeight)
        }
        
        // Draw new image in current graphics context
        let imageRef: CGImageRef = CGImageCreateWithImageInRect(image.CGImage, cropRect)!
        
        // Create new cropped UIImage
        let croppedImage: UIImage = UIImage(CGImage: imageRef)

        let cell = self.tableview.cellForRowAtIndexPath(self.firstIndexPath) as! ProfileEditUserCell
        
        cell.profileImage.image = croppedImage
        
        //user?.profileImage = croppedImage
 //       user?.profileImage = image
        
        //self.tableview.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        
        self.navigationItem.hidesBackButton = true
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            self.firstIndexPath = indexPath
        }
        
        self.indexpaths.append(indexPath)
        print("Appending indexpath for row: " + String(indexPath.row))
        
        var top: ProfileEditUserCell
        var contact: ProfileEditContactCell
        var address: ProfileEditAddressCell
        var description: ProfileEditDescriptionCell
        
        switch indexPath.row {
        case 0:
            top = tableView.dequeueReusableCellWithIdentifier("profileEditUserCell") as! ProfileEditUserCell
            top.profileImage.image = user!.profileImage
            top.name.text = user!.name
            if user!.company == "" {
                top.company.text = "Ikke angivet"
            } else {
                top.company.text = user!.company
            }
            
            if user!.userTitle == "" {
                top.title.text = "Ikke angivet"
            } else {
                top.title.text = user!.userTitle
            }
            
            
            return top

        case 1:
            contact = tableView.dequeueReusableCellWithIdentifier("profileEditContactCell") as! ProfileEditContactCell
            if user!.phoneNo == "" {
                contact.phoneNo.alpha = 0.5
                contact.phoneNo.text = "Ikke angivet"
            } else {
                contact.phoneNo.text = user!.phoneNo
            }
            
            if user!.mobilNo == "" {
                contact.mobilNo.alpha = 0.5
                contact.mobilNo.text = "Ikke angivet"
            } else {
                contact.mobilNo.text = user!.mobilNo
            }
            
            if user!.email == "" {
                contact.email.alpha = 0.5
                contact.email.text = "Ikke angivet"
            } else {
                contact.email.text = user!.email
            }
            
            if user!.website == "" {
                contact.website.alpha = 0.5
                contact.website.text = "Ikke angivet"
            } else {
                contact.website.text = user!.website
            }
            
            return contact
        case 2:
            address = tableView.dequeueReusableCellWithIdentifier("profileEditAddressCell") as! ProfileEditAddressCell
            
            if user!.address == "" {
                address.address.alpha = 0.5
                address.address.text = "Ikke angivet"
            } else {
                address.address.text = user!.address
            }
            address.address.text = user!.address
            return address

        default:
            description = tableView.dequeueReusableCellWithIdentifier("profileEditDescriptionCell") as! ProfileEditDescriptionCell
            description.userDescription.text = user!.userDescription
            return description

        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 1.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return CGFloat(280)
        case 1: return CGFloat(150)
        case 2: return CGFloat(99)
        default: return CGFloat(280)
        }
    }

}
