//
//  Constants.swift
//  CoffeeChat
//
//  Created by HAIYING WENG on 2/2/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation
import UIKit

struct Constants {

    struct Alerts {

        struct LoginFailure {
            static let action = "OK"
            static let message = "Please login with a Cornell email."
            static let title = "Unable to Login"
        }

        struct NoTimesWork {
            static let action = "Try Again"
            static let dismiss = "I'm sure"
            static let message = "Are you sure you can’t find a time that works?"
        }

    }

    struct UserDefaults {
        static let onboardingCompletion = "onboardingCompletion"
        static let userId = "userId"
        static let userFirstName = "userFirstName"
        static let userFullName = "userFullName"
        static let userToken = "userToken"
    }

    struct Onboarding {
        static let nextBottomPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 67)
        static let skipBottomPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 24)
        static let titleLabelPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 64)
    }

}
