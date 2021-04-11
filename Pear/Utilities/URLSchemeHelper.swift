//
//  URLSessionHelper.swift
//  Pear
//
//  Created by Lucy Xu on 3/20/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import UIKit

enum MailType {
    case gmail, mail
}

class URLScheme {
    static func openMail(to email: String, subject: String, type: MailType) {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
        let bodyEncoded = ""
        var urlString: String {
            switch type {
            case .gmail:
                return "googlegmail:///co?to=\(email)&subject=\(subjectEncoded)&body=\(bodyEncoded)"
            case .mail:
                return "mailto:\(email)?subject=\(subjectEncoded)&body=\(bodyEncoded)"
            }
        }

        if let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
}
