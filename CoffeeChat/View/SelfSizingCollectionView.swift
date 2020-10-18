//
//  SelfSizingCollectionView.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 10/18/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

/// SelfSizingCollectionView is a collection view that calculates its own height and does not require height constraints
class SelfSizingCollectionView: UICollectionView {
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }

    override var intrinsicContentSize: CGSize {
        return self.collectionViewLayout.collectionViewContentSize
    }
}
