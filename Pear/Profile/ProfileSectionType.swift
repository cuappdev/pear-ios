//
//  ProfileSectionType.swift
//  Pear
//
//  Created by Lucy Xu on 3/14/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import UIKit

enum ProfileSectionType {

    case basics
    case groups
    case interests
    case matches
    case summary

    var reuseIdentifier: String {
        switch self {
        case .summary:
            return ProfileSummaryTableViewCell.reuseIdentifier
        case .basics:
            return ProfilePromptTableViewCell.reuseIdentifier
        case .interests, .groups, .matches:
            return ProfileSectionTableViewCell.reuseIdentifier
        }
    }

    func getTitle(for user: User) -> String {
        switch self {
        case .summary:
            return "\(user.firstName) \(user.lastName)"
        case .basics:
            return "The basics"
        case .interests:
            return "Things I love"
        case .groups:
            return "Groups I'm a part of"
        case .matches:
            return "Pears I last chatted with"
        }
    }

}
