//
//  UIAlertController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 2/14/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    static func getStandardErrortAlert() -> UIAlertController {
        let standardErrorAlert = UIAlertController(title: "Error", message: "Something went wrong, please try again.", preferredStyle: .alert)
        let standardErrorAlertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        standardErrorAlert.addAction(standardErrorAlertAction)
        return standardErrorAlert
    }

    static func getEmailAlertController(email: String, subject: String) -> UIAlertController {
        let defaultMail = UIAlertAction(title: "Mail (Default)", style: .default) { _ in
            URLScheme.openMail(to: email, subject: subject, type: .mail)
        }

        let gmail = UIAlertAction(title: "Gmail", style: .default) { _ in
            URLScheme.openMail(to: email, subject: subject, type: .gmail)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let alert = UIAlertController(title: "Mail Options", message: nil, preferredStyle: .actionSheet)

        alert.addAction(defaultMail)
        alert.addAction(gmail)
        alert.addAction(cancelAction)

        return alert
    }
    
}
