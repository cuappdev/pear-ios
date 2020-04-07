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
        itemSize = CGSize(
            width: LayoutHelper.shared.getCustomHoriztonalPadding(size: 290),
            height: LayoutHelper.shared.getCustomVerticalPadding(size: 64)
        )
        minimumLineSpacing = LayoutHelper.shared.getCustomHoriztonalPadding(size: 12)
        let width = collectionView?.superview?.bounds.width ?? 0
        headerReferenceSize = .init(width: width, height: LayoutHelper.shared.getCustomVerticalPadding(size: 56))
    }

}

// MARK: - UICollectionView Header
private class InterestHeader: UICollectionReusableView {

    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        // ...
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with title: String, info: String) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 2.0
        style.alignment = .center
        let primaryAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont._20CircularStdBold as Any,
            .paragraphStyle: style,
            .foregroundColor: UIColor.textBlack
        ]
        let secondaryAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont._12CircularStdBook as Any,
            .paragraphStyle: style,
            .foregroundColor: UIColor.greenGray
        ]

        let titleStr = NSMutableAttributedString(string: "\(title)\n", attributes: primaryAttributes)
        let infoStr = NSMutableAttributedString(string: info, attributes: primaryAttributes)
        let combined = NSMutableAttributedString()
        combined.append(titleStr)
        combined.append(infoStr)
        let label.attributedText = combined
    }

}

// MARK: - UIViewController
class EditInterestViewController: UIViewController {

    // MARK: - Private View Vars
    private let locationsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: EditInterestFlowLayout())

    // MARK: - Collection View Sections
    private enum Section {
        case yourInterests([Interest])
        case moreInterests([Interest])
    }

    // MARK: - Data Vars
    private var selectedInterests: [Interest] = []
    private var unselectedInterests: [Interest] = []

    private var interests: [Interest] = [
        Interest(name: "Art", categories: "lorem, lorem, lorem, lorem, lorem", image: "art"),
        Interest(name: "Business", categories: "lorem, lorem, lorem, lorem, lorem", image: "business"),
        Interest(name: "Dance", categories: "lorem, lorem, lorem, lorem, lorem", image: "dance"),
        Interest(name: "Design", categories: "lorem, lorem, lorem, lorem, lorem", image: "design"),
        Interest(name: "Fashion", categories: "lorem, lorem, lorem, lorem, lorem", image: "fashion"),
        Interest(name: "Fitness", categories: "lorem, lorem, lorem, lorem, lorem", image: "fitness"),
        Interest(name: "Food", categories: "lorem, lorem, lorem, lorem, lorem", image: "food"),
        Interest(name: "Humanities", categories: "lorem, lorem, lorem, lorem, lorem", image: "humanities"),
        Interest(name: "Music", categories: "lorem, lorem, lorem, lorem, lorem", image: "music"),
        Interest(name: "Photography", categories: "lorem, lorem, lorem, lorem, lorem", image: "photography"),
        Interest(name: "Reading", categories: "lorem, lorem, lorem, lorem, lorem", image: "reading"),
        Interest(name: "Sustainability", categories: "lorem, lorem, lorem, lorem, lorem", image: "sustainability"),
        Interest(name: "Technology", categories: "lorem, lorem, lorem, lorem, lorem", image: "tech"),
        Interest(name: "Travel", categories: "lorem, lorem, lorem, lorem, lorem", image: "travel"),
        Interest(name: "TV & Film", categories: "lorem, lorem, lorem, lorem, lorem", image: "tvfilm")
    ]

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
        // TODO ...
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // TODO ...
    }

}

// MARK: - UICollectionViewDataSource
extension EditInterestViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO ...
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // TODO implement...
        return UICollectionViewCell()
    }

}
