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

    let senderId: Int
    let recipientId: Int
    let message: String
    let time: String

    init(snapshot: [String: Any]) {
        senderId = snapshot["senderId"] as? Int ?? 0
        recipientId = snapshot["recipientId"] as? Int ?? 0
        message = snapshot["message"] as? String ?? ""
        time = snapshot["time"] as? String ?? ""
    }

    func getMessageHeight(currentUserId: Int) -> CGFloat {
        if senderId == currentUserId {
            return message.height(withConstrainedWidth: 230, font: UIFont.getFont(.book, size: 16))
        } else {
            return message.height(withConstrainedWidth: 210, font: UIFont.getFont(.book, size: 16))
        }
    }

}
