//
//  PearMessage.swift
//  Pear
//
//  Created by Amy Chin Siu Huang on 5/2/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import Firebase
import Foundation

struct PearMessage {

    let senderNetID: String
    let recipientNetID: String
    let message: String
    let time: String

    init(snapshot: [String: Any]) {
        senderNetID = snapshot["senderNetID"] as? String ?? ""
        recipientNetID = snapshot["recipientNetID"] as? String ?? ""
        message = snapshot["message"] as? String ?? ""
        time = snapshot["time"] as? String ?? ""
    }

    func getMessageHeight(currentUserNetID: String) -> CGFloat {
        if senderNetID == currentUserNetID {
            return message.height(withConstrainedWidth: 230, font: UIFont.getFont(.book, size: 16))
        } else {
            return message.height(withConstrainedWidth: 210, font: UIFont.getFont(.book, size: 16))
        }
    }

}
