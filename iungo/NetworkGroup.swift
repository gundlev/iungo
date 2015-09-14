//
//  NetworkGroup.swift
//  iungo
//
//  Created by Niklas Gundlev on 19/08/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
//

import Foundation
import UIKit

class NetworkGroup: NSObject, Comparable {
    
    var name: String
    var id: String
    var size: Int
    var meetingFrequency: String
    var meetDay: String
    var meetTime: String
    var networkDescription: String
    var networkImage: UIImage
    var userStatus: String
    var address: String
    
    
    init(nname: String, nid: String, nsize: Int, nmeetingFrequency: String, nmeetDay: String, nmeetTime: String, nnetworkDescription: String, nnetworkImage: UIImage, nuserStatus: String, naddress: String) {
        self.name = nname
        self.id = nid
        self.size = nsize
        self.meetingFrequency = nmeetingFrequency
        self.meetDay = nmeetDay
        self.meetTime = nmeetTime
        self.networkDescription = nnetworkDescription
        self.networkImage = nnetworkImage
        self.userStatus = nuserStatus
        self.address = naddress
        super.init()
    }
    
    func printAll() {
        print(self.name)
        print(self.size)
        print(self.meetingFrequency)
        print(self.meetDay)
        print(self.meetTime)
        print(self.networkDescription)
        //print(self.networkImage)
        print(self.userStatus)
        print(self.address)
    }
}

func <(lhs: NetworkGroup, rhs: NetworkGroup) -> Bool {
    return lhs.name < rhs.name
}

func ==(lhs: NetworkGroup, rhs: NetworkGroup) -> Bool {
    return lhs.name == rhs.name
}

