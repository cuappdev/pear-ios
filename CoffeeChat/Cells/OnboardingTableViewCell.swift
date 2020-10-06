//
//  OnboardingTableViewCell.swift
//  CoffeeChat
//
//  Created by Phillip OReggio on 2/3/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class OnboardingTableViewCell: UITableViewCell {

    // MARK: Private View Vars
    private let backdropView = UIView()
    private let interestImageView = UIImageView()
    private let titleLabel = UILabel()
    private lazy var categoriesLabel: UILabel = {
        let categoriesLabel = UILabel()
        categoriesLabel.textColor = .greenGray
        categoriesLabel.font = ._12CircularStdBook
        contentView.addSubview(categoriesLabel)
        return categoriesLabel
    }()

    // True if the cell has layed out views at least once
    private var initialized = false
    // Store whether it was showing interests or groups so it doesn't relayout on dequeue
    private var showingInterests = false
    // Whether the cell should change its appearence when setSelected is called
    var shouldSelectionChangeAppearence = true

    static let reuseIdentifier = "OnboardingTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        backgroundColor = .clear
        contentView.backgroundColor = .clear
        backdropView.layer.cornerRadius = 8
        backdropView.layer.masksToBounds = true

        interestImageView.layer.cornerRadius = 4
        backdropView.addSubview(interestImageView)

        titleLabel.textColor = .black
        titleLabel.font = ._16CircularStdBook
        backdropView.addSubview(titleLabel)

        backdropView.clipsToBounds = false
        backdropView.layer.shadowColor = UIColor.black.cgColor
        backdropView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        backdropView.layer.shadowOpacity = 0.1
        backdropView.layer.shadowRadius = 2
        contentView.addSubview(backdropView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints(showingInterests: Bool) {
        let imageSize = CGSize(width: 22, height: 22)
        let sidePadding: CGFloat = 12

        backdropView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(52)
            make.leading.trailing.equalToSuperview()
        }

        interestImageView.snp.remakeConstraints { make in
            make.size.equalTo(imageSize)
            make.leading.equalToSuperview().inset(sidePadding)
            make.centerY.equalToSuperview()
        }

        titleLabel.snp.remakeConstraints { make in
            make.leading.equalTo(interestImageView.snp.trailing).offset(8)
            if showingInterests {
                make.top.equalToSuperview().inset(8.5)
            } else {
                make.centerY.equalToSuperview()
            }
        }

        if showingInterests {
            categoriesLabel.snp.remakeConstraints { make in
                make.leading.equalTo(titleLabel)
                make.top.equalTo(titleLabel.snp.bottom)
            }
        }
    }

    func configure(with interest: Interest) {
        titleLabel.text = interest.name
        categoriesLabel.text = interest.categories
        interestImageView.image = UIImage(named: interest.image)
        // Determine if a relayout is needed (was showing Group and configured with an Interest)
        if !initialized || !showingInterests {
            relayoutSubviews(interests: true)
        }
    }

    func configure(with group: Group) {
        titleLabel.text = group.name
        // Determine if a relayout is needed (was showing Interest and configured with an Group)
        if !initialized || showingInterests {
            relayoutSubviews(interests: false)
        }
    }

    func changeColor(isSelected: Bool) {
        backdropView.backgroundColor = isSelected ? .pearGreen : .white
    }

    /// Removes and resets constraints on the cell. Includes categoriesLabel in the layout if `interests` is true
    private func relayoutSubviews(interests: Bool) {
        showingInterests = interests
        initialized = true
        setupConstraints(showingInterests: showingInterests)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if shouldSelectionChangeAppearence {
            changeColor(isSelected: isSelected)
        }
    }

}
