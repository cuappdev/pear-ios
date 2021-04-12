//
//  SchedulingStatus.swift
//  Pear
//
//  Created by Lucy Xu on 4/11/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

/// The context in which the user is picking times
enum SchedulingStatus {
    /// If the user has no pear, they can input their typical availabilities
    case pickingTypical
    /// If the user reaches out first, they confirm all of their availabilities
    case confirming
    /// If the pear reached out first, the user chooses 1 time from the availabilities
    case choosing
}
