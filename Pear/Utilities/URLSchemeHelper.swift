//
//  URLSessionHelper.swift
//  Pear
//
//  Created by Lucy Xu on 3/20/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import UIKit

class URLScheme {
    static func openGmail(to email: String, subject: String) {
        let emailSubject = subject.replacingOccurrences(of: " ", with: "%20")
        let emailBody = ""
        let googleUrlString = "googlegmail:///co?to=\(email)&subject=\(emailSubject)&body=\(emailBody)"
        if let googleUrl = URL(string: googleUrlString) {
            // show alert to choose app
            if UIApplication.shared.canOpenURL(googleUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(googleUrl, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(googleUrl)
                }
            }
        }
    }
}
