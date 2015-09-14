//
//  User.swift
//  iungo
//
//  Created by Niklas Gundlev on 01/08/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
//

import Foundation
import Swift

class User: NSObject, Comparable {
    
    var name: String
    var userId: String
    var company: String
    var userTitle: String?
    var groups = [String]()
    var meetingStatus = String()
    var address: String?
    var phoneNo: String?
    var mobilNo: String?
    var email: String?
    var website: String?
    // variable that are not yet in the firebase
    var profileImage: UIImage = UIImage()
    var userDescription: String?
    
    init(uname: String, ucompany: String, ugroups: [String], uuserId: String) {
        self.name = uname
        self.company = ucompany
        self.groups = ugroups
        self.userId = uuserId
        super.init()
    }
    
    init(uname: String, ucompany: String, uuserId: String, uuserTitle: String, uaddress: String, uphoneNo: String, umobilNo: String, uemail: String, uwebsite: String, UImage: UIImage, uuserDescription: String, ustatus: String) {
        self.name = uname
        self.company = ucompany
        self.userId = uuserId
        self.userTitle = uuserTitle
        self.address = uaddress
        self.phoneNo = uphoneNo
        self.mobilNo = umobilNo
        self.email = uemail
        self.website = uwebsite
        self.profileImage = UImage
        self.userDescription = uuserDescription
        self.meetingStatus = ustatus
        super.init()
    }
    
    init(uname: String, ucompany: String, status: String, uuserId: String) {
        self.name = uname
        self.company = ucompany
        self.meetingStatus = status
        self.userId = uuserId
        super.init()
    }
    
    func setgroups(g: [String]) {
        self.groups = g
    }
    
    static func jsonToUser(json: JSON, userId: String) -> User {
        
        var profileImage = UIImage(named: "defaultProfileImage")
        
        if json["picture"].stringValue != "" {
            profileImage = UIImage(data: NSData(base64EncodedString: json["picture"].stringValue, options: NSDataBase64DecodingOptions(rawValue: 0))!)!
        }
        
        let user = User(uname: json["name"].stringValue, ucompany: json["company"].stringValue, uuserId: userId, uuserTitle: json["title"].stringValue, uaddress: json["address"].stringValue, uphoneNo: json["phoneNo"].stringValue, umobilNo: json["mobilNo"].stringValue, uemail: json["email"].stringValue, uwebsite: json["website"].stringValue, UImage:profileImage!, uuserDescription: json["description"].stringValue, ustatus: "0")
        
        return user
    }
    
}

func <(lhs: User, rhs: User) -> Bool {
    return lhs.name < rhs.name
}

func ==(lhs: User, rhs: User) -> Bool {
    return lhs.name == rhs.name
}
