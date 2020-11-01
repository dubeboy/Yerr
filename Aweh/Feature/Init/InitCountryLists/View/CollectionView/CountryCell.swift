//
//  CountryCell.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/10/31.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class CountryCell: UICollectionViewCell {
    
    var countryNameLabel = UILabel()
    var rightButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCountryLabel()
        configureRightButton()
        contentView.addDividerLine(to: [.bottom])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setCountryPhoneNumberExtension(ext: String, countryName: String) {
        rightButton.setTitle(ext, for: .normal)
        countryNameLabel.text = countryName
    }
}

extension CountryCell {
    
    private func configureCountryLabel() {
        countryNameLabel.autoresizingOff()
        contentView.addSubview(countryNameLabel)
        countryNameLabel.centerYAnchor --> contentView.centerYAnchor
        countryNameLabel.leadingAnchor --> contentView.leadingAnchor + Const.View.m16
        countryNameLabel.bottomAnchor --> contentView.bottomAnchor + -Const.View.m8
        countryNameLabel.topAnchor --> contentView.topAnchor + Const.View.m8
    }
    
    private func configureRightButton() {
        rightButton.autoresizingOff()
        rightButton.semanticContentAttribute = .forceRightToLeft
        rightButton.setImage(Const.Assets.InitCountryLists.chevronRight, for: .normal)
        contentView.addSubview(rightButton)
        rightButton.trailingAnchor --> contentView.trailingAnchor + -Const.View.m16
        rightButton.centerYAnchor --> contentView.centerYAnchor
        rightButton.topAnchor --> contentView.topAnchor + Const.View.m8
        rightButton.bottomAnchor --> contentView.bottomAnchor + -Const.View.m8
    }
}

