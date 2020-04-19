//
//  OnboardingDropdownCell.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 1/29/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class OnboardingDropdownTableViewCell: UITableViewCell {

    // MARK: Private View Vars
    private let label = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .backgroundLightGrayGreen
        selectionStyle = .none
        
        label.textColor = .textGray
        label.font = UIFont._20CircularStdBook
        label.textColor = .black
        contentView.addSubview(label)

        label.snp.makeConstraints { make in
            make.top.bottom.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(21)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with labelText: String) {
        label.text = labelText
    }

}
