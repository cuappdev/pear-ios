//
//  SelfSizingTableView.swift
//  Pear
//
//  Created by Amy Chin Siu Huang on 8/17/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import UIKit

class SelfSizingTableView: UITableView {

    override var intrinsicContentSize: CGSize {
            self.layoutIfNeeded()
            return self.contentSize
        }

        override var contentSize: CGSize {
            didSet{
                self.invalidateIntrinsicContentSize()
            }
        }

    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }

}
