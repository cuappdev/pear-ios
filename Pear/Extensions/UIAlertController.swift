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
    
}
