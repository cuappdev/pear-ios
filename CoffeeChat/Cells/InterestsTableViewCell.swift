//
//  InterestsTableViewCell.swift
//  CoffeeChat
//
//  Created by Phillip OReggio on 2/3/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class InterestsTableViewCell: UITableViewCell {

    // MARK: Private View Vars
    private var cellBackground = UIView()
    private var interestImage = UIImageView()
    private var titleLabel = UILabel()
    private var categoriesLabel = UILabel()

    // Reuse Identfier
    static let reuseIdentifier = "InterestsTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = .none

        cellBackground.backgroundColor = .backgroundLightGray
        cellBackground.layer.cornerRadius = 4
        contentView.addSubview(cellBackground)

        interestImage.backgroundColor = .backgroundDarkGray
        interestImage.layer.cornerRadius = 2
        contentView.addSubview(interestImage)

        titleLabel.textColor = .textBlack
        titleLabel.font = .systemFont(ofSize: 12, weight: .bold)
        contentView.addSubview(titleLabel)

        categoriesLabel.textColor = .textLightGray
        categoriesLabel.font = .systemFont(ofSize: 6, weight: .regular)
        contentView.addSubview(categoriesLabel)

        setUpConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    private func setUpConstraints() {
        let imageSize = CGSize(width: 16, height: 16)
        let textHeight: CGFloat = 15
        let categoriesHeight: CGFloat = 7.5
        let imagePadding: CGFloat = 6
        let titlePadding: CGFloat = 4

        cellBackground.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        interestImage.snp.makeConstraints { make in
            make.size.equalTo(imageSize)
            make.leading.top.equalToSuperview().inset(imagePadding)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(interestImage).offset(titlePadding)
            make.centerY.equalTo(interestImage)
            make.height.equalTo(textHeight)
        }

        categoriesLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.height.equalTo(categoriesHeight)
            make.top.equalTo(titleLabel.snp.bottom)
        }
    }

    func configure(with interest: Interest) {
        titleLabel.text = interest.name
        categoriesLabel.text = interest.categories
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        cellBackground.backgroundColor = selected ? .backgroundRed : .backgroundLightGray
    }

}
