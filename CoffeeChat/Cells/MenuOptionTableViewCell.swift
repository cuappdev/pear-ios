//
//  MenuOptionTableViewCell.swift
//  CoffeeChat
//
//  Created by HAIYING WENG on 4/4/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class MenuOptionTableViewCell: UITableViewCell {

    private let arrowImageView = UIImageView()
    private let optionImageView = UIImageView()
    private let optionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        arrowImageView.image = UIImage(named: "right_arrow")
        contentView.addSubview(arrowImageView)
        
        optionImageView.clipsToBounds = true
        optionImageView.contentMode = .scaleAspectFit
        contentView.addSubview(optionImageView)

        optionLabel.textColor = .textBlack
        optionLabel.font = ._20CircularStdMedium
        contentView.addSubview(optionLabel)

        setupConstraints()
    }
    
    private func setupConstraints() {
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(30)
            make.height.equalTo(12)
            make.width.equalTo(6)
        }
        
        optionImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(25)
            make.centerY.equalToSuperview()
            make.height.equalTo(45)
            make.width.equalTo(45)
        }
        
        optionLabel.snp.makeConstraints { make in
            make.leading.equalTo(optionImageView.snp.trailing).offset(15)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(for option: MenuOption) {
        optionImageView.image = UIImage(named: option.image)
        optionLabel.text = option.text
        //Create custom selected background
        let backgroundView = UIView()
        backgroundView.backgroundColor = .backgroundLightGrayGreen
        selectedBackgroundView = backgroundView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
