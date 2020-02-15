//
//  MatchSummaryTableViewCell.swift
//  CoffeeChat
//
//  Created by HAIYING WENG on 2/13/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class MatchSummaryTableViewCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let detailLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .backgroundLightGreen
        selectionStyle = .none

        titleLabel.textColor = .textGreen
        titleLabel.font = ._20CircularStdBook
        contentView.addSubview(titleLabel)
        
        detailLabel.textColor = .textBlack
        detailLabel.font = ._20CircularStdMedium
        detailLabel.numberOfLines = 0
        contentView.addSubview(detailLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview()
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.bottom.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func configure(for matchSummary: MatchSummary) {
        titleLabel.text = matchSummary.title
        detailLabel.text = matchSummary.detail
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
