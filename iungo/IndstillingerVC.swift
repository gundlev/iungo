//
//  IndstillingerVC.swift
//  iungo
//
//  Created by Niklas Gundlev on 16/09/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
//

import UIKit

class IndstillingerVC: UIViewController {

    @IBOutlet weak var menu: UIBarButtonItem!
    
    @IBAction func changePassword(sender: AnyObject) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Skift password", message: nil, preferredStyle: .Alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "Email"
        })
        
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "Gammelt password"
        })
        
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "Nyt password"
            textField.secureTextEntry = true
        })
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let email = alert.textFields![0] as UITextField
            let oldPassword = alert.textFields![1] as UITextField
            let newPassword = alert.textFields![2] as UITextField
            
            if (email.text != "" && newPassword.text != "" && oldPassword.text != "") {
                let passwordRef = Firebase(url: "https://brilliant-torch-4963.firebaseio.com")
                passwordRef.changePasswordForUser(email.text!, fromOld: oldPassword.text!,
                    toNew: newPassword.text!, withCompletionBlock: { error in
                        if error != nil {
                            // There was an error processing the request
                            let failAlert = UIAlertController(title: "Der skete en fejl", message: "Email eller password var forkert, eller du har ingen netværksdækning", preferredStyle: .Alert)
                            failAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                            
                            self.presentViewController(failAlert, animated: true, completion: nil)
                            
                        } else {
                            let okAlert = UIAlertController(title: "Dit password er skiftet", message: nil, preferredStyle: .Alert)
                            okAlert.addAction(UIAlertAction(title: "Godt!", style: UIAlertActionStyle.Cancel, handler: nil))
                            
                            self.presentViewController(okAlert, animated: true, completion: nil)
                        }
                })
            }
        }))
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func changeEmail(sender: AnyObject) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Skift email", message: "Det ændre ikke på din offentlige email der står i din profil, men kun på din login-email", preferredStyle: .Alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "Gammel email"
        })
        
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "Ny email"
        })
        
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "Password"
            textField.secureTextEntry = true
        })
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let oldEmail = alert.textFields![0] as UITextField
            let newEmail = alert.textFields![1] as UITextField
            let password = alert.textFields![2] as UITextField
            
            if (oldEmail.text != "" && newEmail.text != "" && password.text != "") {
                let passwordRef = Firebase(url: "https://brilliant-torch-4963.firebaseio.com")
                passwordRef.changeEmailForUser(oldEmail.text!, password: password.text!,
                    toNewEmail: newEmail.text!, withCompletionBlock: { error in
                    if error != nil {
                        // There was an error processing the request
                        let failAlert = UIAlertController(title: "Der skete en fejl", message: "Email eller password var forkert, eller du har ingen netværksdækning", preferredStyle: .Alert)
                        failAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                        
                        self.presentViewController(failAlert, animated: true, completion: nil)
                        
                    } else {
                        let okAlert = UIAlertController(title: "Din Email er skiftet", message: nil, preferredStyle: .Alert)
                        okAlert.addAction(UIAlertAction(title: "Godt!", style: UIAlertActionStyle.Cancel, handler: nil))
                        
                        self.presentViewController(okAlert, animated: true, completion: nil)
                    }
                })
            }
        }))
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        // Setting up the navigation bar
        self.navigationItem.hidesBackButton = true
        let titleDict = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict
        self.navigationController?.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 69/255, green: 143/255, blue: 170/255, alpha: 1)
        
        // Set up menu
        menu.target = self.revealViewController()
        menu.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
}
