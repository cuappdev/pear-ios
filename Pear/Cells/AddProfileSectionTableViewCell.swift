//
//  AddProfileSectionTableViewCell.swift
//  
//
//  Created by Mathew Scullin on 4/24/22.
//

import UIKit
import SnapKit

class AddProfileSectionTableViewCell: UITableViewCell {
    
    // MARK: - Private View Vars
    private let backdropView = UIView()
    private let label = UILabel()
    private let plusImageView = UIImageView()
    
    // MARK: - Data Vars
    static let reuseIdentifier = "AddProfileSectionTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        
        backdropView.backgroundColor = .white
        backdropView.layer.cornerRadius = 8
        backdropView.layer.masksToBounds = true
        backdropView.clipsToBounds = false
        backdropView.layer.shadowColor = UIColor.black.cgColor
        backdropView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        backdropView.layer.shadowOpacity = 0.1
        backdropView.layer.shadowRadius = 2
        contentView.addSubview(backdropView)
        
        plusImageView.image = UIImage(named: "plus")
        backdropView.addSubview(plusImageView)
        
        label.font = ._16CircularStdBook
        label.textColor = .inactiveGreen
        backdropView.addSubview(label)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        backdropView.snp.makeConstraints { make in
//            make.verticalEdges.equalToSuperview().inset(4)
            make.height.equalTo(48)
//            make.horizontalEdges.equalToSuperview()
        }
        
        plusImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(14)
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(plusImageView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with labelText: String) {
        label.text = labelText
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
