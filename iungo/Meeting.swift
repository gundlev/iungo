//
//  Meeting.swift
//  iungo
//
//  Created by Niklas Gundlev on 21/07/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
//

import Foundation
import Swift

class Meeting: NSObject, Comparable {
    
    var id: String
    var groupId: String
    var meetingTitle: String
    var meetingText: String
    var startTimestamp: Int?
    var endTimestamp: Int?
    var participants = [Dictionary<String,Int>]()
    var date: String
    var status: Int = 0
    var time: String
    var address: String
    var name: String
    var numberOfParticipating: Int
    
//    init(oid: String, ogroupId: String, otitle: String, otext: String, odate: String, otime:String, oaddress: String, oname: String, onumber: Int) {
//        self.id = oid
//        self.groupId = ogroupId
//        self.meetingTitle = otitle
//        self.meetingText = otext
//        self.date = odate
//        self.time = otime
//        self.address = oaddress
//        self.name = oname
//        self.numberOfParticipating = onumber
//    }
    
    init(oid: String, ogroupId: String, otitle: String, otext: String, ostart: Int, oend:Int, oaddress: String, oname: String, onumber: Int) {
        self.id = oid
        self.groupId = ogroupId
        self.meetingTitle = otitle
        self.meetingText = otext
        self.startTimestamp = ostart
        self.endTimestamp = oend
        self.address = oaddress
        self.name = oname
        self.numberOfParticipating = onumber
        self.date = ""
        self.time = ""
    }
    
    func setParticipant(userid: String, status: Int) {
        let part = [userid:status]
        participants.append(part)
    }
    
    static func jsonToMeeting(json:JSON, mid: String, network: String, groupId: String) -> Meeting {
        
        var numberOfParticipating = 0
        for (_, status) in json["participants"] {
            if status["status"].intValue == 1 {
                numberOfParticipating++
            }
        }
        
        let meeting = Meeting(oid: mid, ogroupId: groupId, otitle: json["title"].stringValue, otext: json["text"].stringValue, ostart: json["startTimestamp"].intValue, oend: json["endTimestamp"].intValue, oaddress: json["address"].stringValue, oname: network, onumber: numberOfParticipating)
        
        return meeting
        
    }
}

func <(lhs: Meeting, rhs: Meeting) -> Bool {
    return lhs.startTimestamp! < rhs.startTimestamp!
}

func ==(lhs: Meeting, rhs: Meeting) -> Bool {
    return lhs.startTimestamp! == rhs.startTimestamp!
}
