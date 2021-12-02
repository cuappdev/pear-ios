//
//  OnboardingTableViewCell.swift
//  Pear
//
//  Created by Lucy Xu on 5/15/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import Kingfisher
import UIKit

class OnboardingTableViewCell: UITableViewCell {

    private let onboardingView = OnboardingView()

    // Whether the cell should change its appearence when selected
    var shouldSelectionChangeAppearence = true

    static let reuseIdentifier = "OnboardingTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        backgroundColor = .clear
        contentView.addSubview(onboardingView)
        
        onboardingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func configure(with interest: Interest) {
        onboardingView.configure(with: interest)
    }

    func configure(with group: Group) {
        onboardingView.configure(with: group)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        if shouldSelectionChangeAppearence {
            onboardingView.changeColor(selected: selected)
        }
        super.setSelected(selected, animated: animated)

    }

    func changeColor(selected: Bool) {
        onboardingView.changeColor(selected: selected)
    }

}
