//
//  MessageUser.swift
//  Pear
//
//  Created by Amy Chin Siu Huang on 5/2/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import Foundation

struct MessageUser {

    let netID: String
    let firstName: String
    let lastName: String
    let status: String
    var meetingTime: Float?
    let profilePictureURL: String
    var messageTimeStamp: String

//    func getTime() -> String {
//        var time: String = ""
//        let dateFormatter = DateFormatter()
//        let timeSince1970 = Double(self.messageTimeStamp)
//        let messageDate = NSDate(timeIntervalSince1970: timeSince1970!)
//        if Calendar.current.isDateInToday(messageDate as Date) {
//            dateFormatter.dateFormat = "hh:mm a"
//            time = dateFormatter.string(from: messageDate as Date)
//        }
//        else if Calendar.current.isDateInYesterday(messageDate as Date) {
//            time = "Yesterday"
//        }
//        else {
//            dateFormatter.dateFormat = "MM/dd/yy"
//            time = dateFormatter.string(from: messageDate as Date)
//        }
//        return time
//    }

}
