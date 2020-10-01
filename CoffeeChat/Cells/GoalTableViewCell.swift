//
//  GoalTableViewCell.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 9/16/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class GoalTableViewCell: UITableViewCell {

    // MARK: Private View Vars
    private let backdropView = UIView()
    private let titleLabel = UILabel()
    static let reuseIdentifier = "GoalTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        backgroundColor = .backgroundLightGreen

        backdropView.backgroundColor = .clear
        backdropView.clipsToBounds = false
        backdropView.layer.shadowColor = UIColor.black.cgColor
        backdropView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        backdropView.layer.shadowOpacity = 0.1
        backdropView.layer.shadowRadius = 2
        backdropView.layer.cornerRadius = 8
        backdropView.layer.masksToBounds = true
        contentView.addSubview(backdropView)

        titleLabel.textColor = .textBlack
        titleLabel.font = ._16CircularStdBook
        backdropView.addSubview(titleLabel)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {

        backdropView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(5)
        }

        titleLabel.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
    }

    func configure(with goal: String) {
        titleLabel.text = goal
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backdropView.backgroundColor = selected ? .pearGreen : .white
    }

}

