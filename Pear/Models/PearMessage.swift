//
//  PearMessage.swift
//  Pear
//
//  Created by Amy Chin Siu Huang on 5/2/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import Foundation
import Firebase

class PearMessage {

    var senderNetID: String
    var recipientNetID: String
    var message: String
    var time: String

    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: Any]
        self.senderNetID = snapshotValue["senderNetID"] as? String ?? ""
        self.recipientNetID = snapshotValue["recipientNetID"] as? String ?? ""
        self.message = snapshotValue["message"] as? String ?? ""
        self.time = snapshotValue["time"] as? String ?? ""
    }

    func getMessageHeight(currentUserNetID: String) -> CGFloat {
        var messageLabel: UILabel
        if self.senderNetID == currentUserNetID {
            messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 230, height: CGFloat.greatestFiniteMagnitude))
        }
        else {
            messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: CGFloat.greatestFiniteMagnitude))
        }
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.getFont(.book, size: 16)
        messageLabel.text = self.message
        messageLabel.sizeToFit()
        let messageHeight = messageLabel.frame.height + 30
        return messageHeight
    }

}
