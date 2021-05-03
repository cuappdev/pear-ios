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

    func getRecipientNetID(currentUserNetID: String) -> String {
        return currentUserNetID == senderNetID ? recipientNetID : senderNetID
    }

}
