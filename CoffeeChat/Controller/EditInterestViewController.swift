//
//  EditInterestVireController.swift
//  CoffeeChat
//
//  Created by Phillip OReggio on 3/11/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

// MARK: - UICollectionViewFlowLayout
private class EditInterestFlowLayout: UICollectionViewFlowLayout {

    override func prepare() {
        // ...
    }
}

// MARK: - UICollectionView Header
private class InterestHeader: UICollectionReusableView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        // ...
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with text: String) {
        // ...?
    }

}

// MARK: - UIViewController
class EditInterestViewController: UIViewController {

    // MARK: - Private View Vars

    // MARK: - Collection View Sections

    // MARK: - Data Vars

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundLightGreen

        setupConstraints()
    }

    private func setupConstraints() {
        //...
    }

}

// MARK: - UICollectionViewDelegate
extension EditInterestViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        <#code#>
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        <#code#>
    }

}

// MARK: - UICollectionViewDataSource
extension EditInterestViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }

}
