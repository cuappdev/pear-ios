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
    private let cellBackgroundView = UIView()
    private let interestImageView = UIImageView()
    private let titleLabel = UILabel()
    private lazy var categoriesLabel: UILabel = {
        let categoriesLabel = UILabel()
        categoriesLabel.textColor = .textLightGray
        categoriesLabel.font = .systemFont(ofSize: 12, weight: .regular)
        cellBackgroundView.addSubview(categoriesLabel)
        return categoriesLabel
    }()

    // True if the cell has layed out views at least once
    private var initialized = false
    // Store whether it was showing interests or groups so it doesn't relayout on dequeue
    private var showingInterests = false

    static let reuseIdentifier = "OnboardingTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = .none

        cellBackgroundView.backgroundColor = .backgroundLightGray
        cellBackgroundView.layer.cornerRadius = 8
        contentView.addSubview(cellBackgroundView)

        interestImageView.backgroundColor = .backgroundDarkGray
        interestImageView.layer.cornerRadius = 4
        cellBackgroundView.addSubview(interestImageView)

        titleLabel.textColor = .textBlack
        titleLabel.font = .systemFont(ofSize: 20, weight: .regular)
        cellBackgroundView.addSubview(titleLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints(showingInterests: Bool) {
        let imageSize = CGSize(width: 32, height: 32)
        let sidePadding: CGFloat = 12
        let textSidePadding: CGFloat = 8

        cellBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        interestImageView.snp.makeConstraints { make in
            make.size.equalTo(imageSize)
            make.leading.equalToSuperview().inset(sidePadding)
            make.centerY.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(interestImageView.snp.trailing).offset(textSidePadding)
            if showingInterests {
                make.top.equalTo(cellBackgroundView).inset(sidePadding)
            } else {
                make.centerY.equalToSuperview()
            }
        }

        if showingInterests {
            categoriesLabel.snp.makeConstraints { make in
                make.leading.equalTo(titleLabel)
                make.top.equalTo(titleLabel.snp.bottom)
            }
        }
    }

    func configure(with interest: Interest) {
        titleLabel.text = interest.name
        categoriesLabel.text = interest.categories
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

    /// Removes and resets constraints on the cell. Includes categoriesLabel in the layout if `interests` is true
    private func relayoutSubviews(interests: Bool) {
        showingInterests = interests
        initialized = true
        cellBackgroundView.subviews.forEach { $0.removeConstraints($0.constraints)}
        setupConstraints(showingInterests: showingInterests)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        cellBackgroundView.backgroundColor = isSelected ? .backgroundRed : .backgroundLightGray
    }

}
