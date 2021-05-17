//
//  UITableView.swift
//  Pear
//
//  Created by Amy Chin Siu Huang on 5/9/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import UIKit

extension UITableView {

    func isValid(indexPath: IndexPath) -> Bool {
        if indexPath.section >= numberOfSections || indexPath.row >= numberOfRows(inSection: indexPath.section) {
            return false
        }
        return true
    }

}
