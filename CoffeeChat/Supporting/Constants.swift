//
//  Constants.swift
//  CoffeeChat
//
//  Created by HAIYING WENG on 2/2/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation

struct Constants {

    struct Alerts {
        struct LoginFailure {
            static let action = "OK"
            static let message = "Please login with a Cornell email."
            static let title = "Unable to Login"
        }
    }

    struct UserDefaults {
        static let onboardingCompletion = "onboardingCompletion"
        static let userId = "userId"
        static let userFirstName = "userFirstName"
        static let userFullName = "userFullName"
        static let userIdToken = "userIdToken"
        static let userClubs = "userClubs"
        static let userGraduationYear = "userGraduationYear"
        static let userHometown = "userHometown"
        static let userInterests = "userInterests"
        static let userMajor = "userMajor"
        static let userPronouns = "userPronouns"
    }
}
