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

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let tagsCollectionViewLayout = LeftAlignedFlowLayout()
        tagsCollectionViewLayout.minimumInteritemSpacing = 4
        tagsCollectionViewLayout.minimumLineSpacing = 4
        super.init(frame: frame, collectionViewLayout: tagsCollectionViewLayout)
    }
    
    override var intrinsicContentSize: CGSize {
        return self.collectionViewLayout.collectionViewContentSize
    }
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
