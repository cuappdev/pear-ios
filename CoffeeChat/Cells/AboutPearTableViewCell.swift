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
    static let aboutReuseId = "aboutReuseId"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        paragraphLabel.numberOfLines = 0
        paragraphLabel.backgroundColor = .clear
        contentView.addSubview(paragraphLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        paragraphLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(36)
            make.centerY.equalTo(contentView.snp.centerY)
        }
    }
    
    func configure(for aboutParagraph: AboutParagraph) {
        paragraphLabel.attributedText = NSMutableAttributedString().boldFont16(aboutParagraph.bold).regularFont16(aboutParagraph.regular)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

fileprivate extension NSMutableAttributedString {

    func boldFont16(_ value: String) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: UIFont] = [.font: UIFont.getFont(.bold, size: 16)]
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func regularFont16(_ value: String) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: UIFont] = [.font: UIFont.getFont(.book, size: 16)]
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
}
