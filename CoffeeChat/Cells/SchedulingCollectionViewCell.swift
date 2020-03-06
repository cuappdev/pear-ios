//
//  SchedulingCollectionViewCell.swift
//  CoffeeChat
//
//  Created by Phillip OReggio on 3/4/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class SchedulingCollectionViewCell: UICollectionViewCell {

    // MARK: Private view vars
    private let button = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        self.layer.masksToBounds = false

        button.isUserInteractionEnabled = false
        button.setTitleColor(.textBlack, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = UIFont._16CircularStdBook
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0);
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.layer.shadowOpacity = 0.15
        button.layer.shadowRadius = 2
        changeSelection(selected: false)
        contentView.addSubview(button)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(
              CGSize(
                width: LayoutHelper.shared.getCustomHoriztonalPadding(size: 150),
                height: LayoutHelper.shared.getCustomVerticalPadding(size: 43)
            ))
        }
    }

    func configure(with title: String) {
        button.setTitle(title, for: .normal)
    }

    func changeSelection(selected: Bool) {
        button.backgroundColor = selected ? .pearGreen : .backgroundWhite
    }

}
