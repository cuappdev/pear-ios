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
        // Login
        static let accessToken = "accessToken"
        static let onboardingCompletion = "onboardingCompletion"
        static let refreshToken = "refreshToken"
        static let sessionExpiration = "sessionExpiration"

        // User Info
        static let userFirstName = "userFirstName"
        static let userFullName = "userFullName"
        static let userGraduationYear = "userGraduationYear"
        static let userHometown = "userHometown"
        static let userIdToken = "userIdToken"
        static let userMajor = "userMajor"
        static let userNetId = "userNetId"
        static let userProfilePictureURL = "userProfilePictureURL"
        static let userPronouns = "userPronouns"

        // Matching
        static let matchIDLastReachedOut = "matchIDLastReachedOut"

        // Form Showing
        static let previousMatchHistorySize = "previousMatchHistorySize"
    }

    struct Match {
        // Match status
        static let created = "created"
        static let proposed = "proposed"
        static let cancelled = "cancelled"
        static let active = "active"
        static let inactive = "inactive"

        // Match day of week
        static let sunday = "sunday"
        static let monday = "monday"
        static let tuesday = "tuesday"
        static let wednesday = "wednesday"
        static let thursday = "thursday"
        static let friday = "friday"
        static let saturday = "saturday"
    }

    struct Onboarding {
        static let nextBottomPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 67)
        static let skipBottomPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 24)
        static let titleLabelPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 64)
        static let backButtonSize = CGSize(width: 25, height: 25)
        static let mainButtonSize = CGSize(width: 225, height: 54)
    }
    
    struct Options {
        static let hometownSearchFields = ["Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "International", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"]
        
        static let organizations = [
            Group(name: "Cornell AppDev", imageName: "appdev"),
            Group(name: "The Milstein Program in Technology in Humanity", imageName: "milstein"),
            Group(name: "Under Represented User Experience (URUX)", imageName: "urux"),
            Group(name: "Women in Computing at Cornell (WICC)", imageName: "wicc")
        ]
        
        static let organizationsMap: [String: Group] = [
            "Cornell AppDev": Group(name: "Cornell AppDev", imageName: "appdev"),
            "The Milstein Program in Technology in Humanity": Group(name: "The Milstein Program in Technology in Humanity", imageName: "milstein"),
            "Under Represented User Experience (URUX)": Group(name: "Under Represented User Experience (URUX)", imageName: "urux"),
            "Women in Computing at Cornell (WICC)": Group(name: "Women in Computing at Cornell (WICC)", imageName: "wicc")
        ]
        
        static let interests: [Interest] = [
            Interest(name: "Art", categories: ["painting", "crafts", "embroidery"], imageName: "art"),
            Interest(name: "Business", categories: ["entrepreneurship", "finance", "VC"], imageName: "business"),
            Interest(name: "Dance", categories: ["urban, hip hop", "ballet", "swing"], imageName: "dance"),
            Interest(name: "Design", categories: ["UI/UX", "graphic", "print"], imageName: "design"),
            Interest(name: "Fashion", categories: nil, imageName: "fashion"),
            Interest(name: "Fitness", categories: ["working out", "outdoors", "basketball"], imageName: "fitness"),
            Interest(name: "Food", categories: ["cooking", "eating", "baking"], imageName: "food"),
            Interest(name: "Humanities", categories: ["history", "politics"], imageName: "humanities"),
            Interest(name: "Music", categories: ["instruments", "producing", "acapella"], imageName: "music"),
            Interest(name: "Photography", categories: ["digital", "analog"], imageName: "photography"),
            Interest(name: "Reading", categories: nil, imageName: "reading"),
            Interest(name: "Sustainability", categories: nil, imageName: "sustainability"),
            Interest(name: "Tech", categories: ["programming", "web/app development"], imageName: "tech"),
            Interest(name: "Travel", categories: ["road", "trips", "backpacking"], imageName: "travel"),
            Interest(name: "TV & Film", categories: nil, imageName: "tv&film")
        ]
        
        static let pronounSearchFields = ["She/Her/Hers", "He/Him/His", "They/Them/Theirs"]
        
        static let interestsMap: [String: Interest] = [
            "Art": Interest(name: "Art", categories: ["painting", "crafts", "embroidery"], imageName: "art"),
            "Business": Interest(name: "Business", categories: ["entrepreneurship", "finance", "VC"], imageName: "business"),
            "Dance": Interest(name: "Dance", categories: ["urban, hip hop", "ballet", "swing"], imageName: "dance"),
            "Design": Interest(name: "Design", categories: ["UI/UX", "graphic", "print"], imageName: "design"),
            "Fashion": Interest(name: "Fashion", categories: nil, imageName: "fashion"),
            "Fitness": Interest(name: "Fitness", categories: ["working out", "outdoors", "basketball"], imageName: "fitness"),
            "Food": Interest(name: "Food", categories: ["cooking", "eating", "baking"], imageName: "food"),
            "Humanities": Interest(name: "Humanities", categories: ["history", "politics"], imageName: "humanities"),
            "Music": Interest(name: "Music", categories: ["instruments", "producing", "acapella"], imageName: "music"),
            "Photography": Interest(name: "Photography", categories: ["digital", "analog"], imageName: "photography"),
            "Reading": Interest(name: "Reading", categories: nil, imageName: "reading"),
            "Sustainability": Interest(name: "Sustainability", categories: nil, imageName: "sustainability"),
            "Tech": Interest(name: "Tech", categories: ["programming", "web/app development"], imageName: "tech"),
            "Travel": Interest(name: "Travel", categories: ["road", "trips", "backpacking"], imageName: "travel"),
            "TV & Film": Interest(name: "TV & Film", categories: nil, imageName: "tv&film")
        ]
    }

}
