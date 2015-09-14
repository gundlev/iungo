//
//  LoginVC.swift
//  iungo
//
//  Created by Niklas Gundlev on 01/09/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController, UITextFieldDelegate {
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var wheel: UIActivityIndicatorView!
    
    @IBAction func login(sender: AnyObject) {
        
        wheel.hidden = false
        wheel.startAnimating()
        let ref = Firebase(url: "https://brilliant-torch-4963.firebaseio.com")
        ref.authUser(email.text, password: password.text,
            withCompletionBlock: { error, authData in
                if error != nil {
                    // There was an error logging in to this account
                    print("There was an error logging in to this account")
                    self.wheel.stopAnimating()
                } else {
                    // We are now logged in
                    print("We are now logged in")
                    
                    
//                    userDefaults.setObject(authData.uid, forKey: "uid")
//                    userDefaults.setObject(authData.providerData["email"], forKey: "email")
                    
                    let url = ("https://brilliant-torch-4963.firebaseio.com/users/" + authData.uid)

                    print(url)
                    let ref = Firebase(url: url)
                    
                    ref.childByAppendingPath("device_token").setValue(self.userDefaults.stringForKey("device_token"))
                    ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
                        
                        let userJson = JSON(snapshot.value)
                        print("Have gotten the user data")
                        //print(userJson)
                        
//                        let localuser = User(uname: userJson["name"].stringValue, ucompany: userJson["company"].stringValue, uuserId: authData.uid, uuserTitle: userJson["title"].stringValue, uaddress: userJson["address"].stringValue, uphoneNo: userJson["phoneNo"].stringValue, uemail: authData.providerData["email"] as! String, uwebsite: userJson["website"].stringValue, UImage: UIImage(data: NSData(base64EncodedString: userJson["picture"].stringValue, options: NSDataBase64DecodingOptions(rawValue: 0))!)!, uuserDescription: userJson["description"].stringValue, ustatus: "0")
//                        
//                        
//                        userDefaults.setObject(localuser, forKey: "user")
                        
                        self.userDefaults.setObject(authData.uid, forKey: "uid")
                        self.userDefaults.setObject(authData.providerData["email"], forKey: "email")
                        self.userDefaults.setObject(userJson["name"].stringValue, forKey: "name")
                        self.userDefaults.setObject(userJson["address"].stringValue, forKey: "address")
                        self.userDefaults.setObject(userJson["company"].stringValue, forKey: "company")
                        self.userDefaults.setObject(userJson["description"].stringValue, forKey: "description")
                        self.userDefaults.setObject(userJson["mobilNo"].stringValue, forKey: "mobilNo")
                        self.userDefaults.setObject(userJson["phoneNo"].stringValue, forKey: "phoneNo")
                        self.userDefaults.setObject(userJson["picture"].stringValue, forKey: "picture")
                        self.userDefaults.setObject(userJson["title"].stringValue, forKey: "title")
                        self.userDefaults.setObject(userJson["website"].stringValue, forKey: "website")
                        self.go()
                        self.wheel.startAnimating()
                    })

                    
                }
        })

    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func go() {
        performSegueWithIdentifier("nowLoggedIn", sender: self)
    }
    
    override func viewDidLoad() {
        wheel.hidesWhenStopped = true
        wheel.hidden = true
        let ref = Firebase(url: "https://brilliant-torch-4963.firebaseio.com")
        if ref.authData != nil {
            let url = ("https://brilliant-torch-4963.firebaseio.com/users/" + userDefaults.stringForKey("uid")!)
            let ref = Firebase(url: url)
            ref.childByAppendingPath("device_token").setValue("")
            
            ref.unauth()
            
        } else {
            print("not logged in")
        }
        let whiteColor = UIColor.whiteColor()
        email.layer.borderColor = whiteColor.CGColor
        password.layer.borderColor = whiteColor.CGColor
    }
    
}
