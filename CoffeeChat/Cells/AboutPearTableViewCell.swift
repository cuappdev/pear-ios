//
//  AboutPearTableViewCell.swift
//  CoffeeChat
//
//  Created by Amy Chin Siu Huang on 10/11/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class AboutPearTableViewCell: UITableViewCell {

    private let paragraphLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        contentView.backgroundColor = .backgroundLightGreen
        paragraphLabel.numberOfLines = 0
        paragraphLabel.backgroundColor = .clear
        contentView.addSubview(paragraphLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        paragraphLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(36)
            make.trailing.equalToSuperview().inset(36)
            make.centerY.equalTo(contentView.snp.centerY)
        }
    }
    
    func configure(for aboutParagraph: AboutParagraph) {
        let boldText = aboutParagraph.bold
        let boldTextAttributes = [NSAttributedString.Key.font : UIFont.getFont(.bold, size: 16)]
        let boldAttributedText = NSMutableAttributedString(string: boldText, attributes: boldTextAttributes as [NSAttributedString.Key : Any])
        
        let regularText = aboutParagraph.regular
        let regularTextAttributes = [NSAttributedString.Key.font : UIFont.getFont(.book, size: 16)]
        let regularAttributedText = NSMutableAttributedString(string: regularText, attributes: regularTextAttributes as [NSAttributedString.Key : Any])
        
        boldAttributedText.append(regularAttributedText)
        paragraphLabel.attributedText = boldAttributedText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
