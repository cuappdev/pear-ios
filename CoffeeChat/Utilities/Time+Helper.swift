//
//  Time+Helper.swift
//  CoffeeChat
//
//  Created by HAIYING WENG on 4/26/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation

class Time {

    static let amTimes = ["9:00", "9:30", "10:00", "10:30", "11:00", "11:30"]
    static let pmTimes = ["12:00", "12:30", "1:00", "1:30", "2:00", "2:30", "3:00", "3:30", "4:00", "4:30", "5:00", "5:30", "6:00", "6:30", "7:00", "7:30", "8:00", "8:30"]
    
    static func isAm(time: String) -> Bool {
        return amTimes.contains(time)
    }
    
    static func isPm(time: String) -> Bool {
        return pmTimes.contains(time)
    }

}
