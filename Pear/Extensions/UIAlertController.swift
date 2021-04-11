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

    static func getEmailAlertController(email: String) -> UIAlertController {
        let defaultMail = UIAlertAction(title: "Mail (Default)", style: .default) { (action) in
        }

        let gmail = UIAlertAction(title: "Gmail", style: .default) { (action) in
            URLScheme.openGmail(to: email, subject: "")
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }

        // Create and configure the alert controller.
        let alert = UIAlertController(title: "Mail Options", message: nil, preferredStyle: .actionSheet)

        alert.addAction(defaultMail)
        alert.addAction(gmail)
        alert.addAction(cancelAction)

        return alert
    }
    
}
