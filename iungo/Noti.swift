//
//  Noti.swift
//  iungo
//
//  Created by Niklas Gundlev on 03/09/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
//

import Foundation
import Firebase

class Noti: NSObject, Comparable {
    
    var notiText: String
    var from: String
    var notiId: String
    var read: Bool
    var reference: String
    var timestamp: String
    var type: String
    var meeting: Meeting?
    var user: User?
    var networkGroup: NetworkGroup?
    
    init(nnotiText: String, nfrom: String, nnotiId: String, nread: Bool, nreference: String, ntimestamp: String, ntype: String) {
        self.notiText = nnotiText
        self.from = nfrom
        self.notiId = nnotiId
        self.read = nread
        self.reference = nreference
        self.timestamp = ntimestamp
        self.type = ntype
    }
    
//    func setMeeting(reference: String) {
//        
//        let ref = Firebase(url: "https://brilliant-torch-4963.firebaseio.com" + reference)
//        ref.observeSingleEventOfType(.Value) { (snapshot) -> Void in
//            
//        }
//    }
}

func <(lhs: Noti, rhs: Noti) -> Bool {
    return lhs.timestamp < rhs.timestamp
}

func ==(lhs: Noti, rhs: Noti) -> Bool {
    return lhs.timestamp == rhs.timestamp
}
