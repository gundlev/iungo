//
//  AppDelegate.swift
//  iungo
//
//  Created by Niklas Gundlev on 18/07/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let userDefaults = NSUserDefaults.standardUserDefaults()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //Firebase.defaultConfig().persistenceEnabled = true
        
        
        if let appHasBeenLaunched = userDefaults.stringForKey("usage") {
            print("The app has been launched before")
            if appHasBeenLaunched == "firstTime" {
                userDefaults.setObject("beenHere", forKey: "usage")
            }
        } else {
            print("This is the first time the user is opening the app")
            userDefaults.setObject("firstTime", forKey: "usage")
            let ref = Firebase(url: "https://brilliant-torch-4963.firebaseio.com")
            ref.unauth()
        }
        userDefaults.setBool(true, forKey: "firstTime")
        
//        if var topController = UIApplication.sharedApplication().keyWindow?.rootViewController {
//            while let presentedViewController = topController.presentedViewController {
//                topController = presentedViewController
//            }
//            
//            let profileAlert = UIAlertController(title: "Der mangler vigtige oplysninger i din profil 1", message: "Vil du gå til profilen ændret det?", preferredStyle: .Alert)
//            profileAlert.addAction(UIAlertAction(title: "Ja!", style: UIAlertActionStyle.Cancel, handler: nil))
//            
//            topController.presentViewController(profileAlert, animated: true, completion: nil)
//            
//            // topController should now be your topmost view controller
//        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("This is the token:")
        print(deviceToken.description)
        
        var devTokenRaw = deviceToken.description
        var devToken = devTokenRaw.stringByReplacingOccurrencesOfString("<", withString: "").stringByReplacingOccurrencesOfString(">", withString: "")
        print(devToken)
        userDefaults.setObject(devToken, forKey: "device_token")
        
        let url = ("https://brilliant-torch-4963.firebaseio.com/users/" + userDefaults.stringForKey("uid")!)
        
        print(url)
        let ref = Firebase(url: url)
        ref.childByAppendingPath("device_token").setValue(devToken)

    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        // What to do when app recieves notification
        // let title : String =  userInfo["title"] as! String
        // UIApplication.sharedApplication().applicationIconBadgeNumber++
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        if (self.userDefaults.stringForKey("company") == "" || self.userDefaults.stringForKey("description") == "" || self.userDefaults.stringForKey("picture") == "" || self.userDefaults.stringForKey("title") == "" || (self.userDefaults.stringForKey("phoneNo") == "" || self.userDefaults.stringForKey("mobilNo") == "")) {
        
            if var topController = UIApplication.sharedApplication().keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                
                let profileAlert = UIAlertController(title: "Der mangler vigtige oplysninger i din profil 2", message: "Vil du gå til profilen ændret det?", preferredStyle: .Alert)
                profileAlert.addAction(UIAlertAction(title: "Ja!", style: UIAlertActionStyle.Cancel, handler: nil))
                
                topController.presentViewController(profileAlert, animated: true, completion: nil)
                
                // topController should now be your topmost view controller
            }
        }
        
        print("will enter foreground")
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        
        
//        let profileAlert = UIAlertController(title: "Der mangler vigtige oplysninger i din profil", message: "Vil du gå til profilen ændret det?", preferredStyle: .Alert)
//        profileAlert.addAction(UIAlertAction(title: "Ja!", style: UIAlertActionStyle.Cancel, handler: nil))
//        
//        window!.rootViewController?.presentViewController(profileAlert, animated: true, completion: nil)
//        self.window?.rootViewController?.presentViewController(profileAlert, animated: true, completion: nil)
//        self.presentViewController(emailAlert, animated: true, completion: {
//            
//        })

        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.gundlev.iungo" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("iungo", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}

