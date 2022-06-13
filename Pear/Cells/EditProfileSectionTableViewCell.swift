//
//  EditProfileSectionTableViewCell.swift
//  Pear
//
//  Created by Mathew Scullin on 4/24/22.
//  Copyright © 2022 cuappdev. All rights reserved.
//

import Kingfisher
import UIKit

class EditProfileSectionTableViewCell: UITableViewCell {

    // MARK: Private View Vars
    private let backdropView = UIView()
    private let categoriesLabel = UILabel()
    private let closeButton = UIButton()
    private let interestImageView = UIImageView()
    private let titleLabel = UILabel()

    // MARK: - Data Vars
    static let reuseIdentifier = "EditProfileSectionTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        interestImageView.layer.cornerRadius = 4
        backdropView.addSubview(interestImageView)

        titleLabel.textColor = .black
        titleLabel.font = ._16CircularStdBook
        backdropView.addSubview(titleLabel)

        backdropView.layer.cornerRadius = 8
        backdropView.layer.masksToBounds = true
        backdropView.backgroundColor = .white
        backdropView.clipsToBounds = false
        backdropView.layer.shadowColor = UIColor.black.cgColor
        backdropView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        backdropView.layer.shadowOpacity = 0.1
        backdropView.layer.shadowRadius = 2
        contentView.addSubview(backdropView)
        
        closeButton.setImage(UIImage(named: "closeButton"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        backdropView.addSubview(closeButton)

        categoriesLabel.textColor = .greenGray
        categoriesLabel.font = ._12CircularStdBook
        contentView.addSubview(categoriesLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let imageSize = CGSize(width: 22, height: 22)
        
        closeButton.snp.makeConstraints { make in
            make.size.equalTo(12)
            make.top.trailing.equalToSuperview().inset(12)
        }
        
        backdropView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.height.equalTo(52)
            make.horizontalEdges.equalToSuperview()
        }

        interestImageView.snp.remakeConstraints { make in
            make.size.equalTo(imageSize)
            make.leading.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }

        titleLabel.snp.remakeConstraints { make in
            make.leading.equalTo(interestImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(12)
            if categoriesLabel.text != nil {
                make.top.equalToSuperview().inset(8.5)
            } else {
                make.centerY.equalToSuperview()
            }
        }

        categoriesLabel.isHidden = categoriesLabel.text == nil
        categoriesLabel.snp.remakeConstraints { make in
             make.leading.equalTo(titleLabel)
             make.top.equalTo(titleLabel.snp.bottom)
        }
    }

    func configure(with interest: Interest) {
        titleLabel.text = interest.name
        categoriesLabel.text = interest.subtitle
        if let interestImageUrl = URL(string: interest.imgUrl) {
            interestImageView.kf.setImage(with: interestImageUrl)
        }
        setupConstraints()
    }

    func configure(with group: Group) {
        titleLabel.text = group.name
        categoriesLabel.text = nil
        if let groupImageUrl = URL(string: group.imgUrl) {
            interestImageView.kf.setImage(with: groupImageUrl)
        }
        setupConstraints()
    }
    
    
    @objc private func closeButtonPressed() {
        //TODO: Add delete functionality
        print("Close button")
    }
    
}
