//
//  InterestsCellPresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/24.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

class InterestsCellPresenter {
    func configure(_ cell: InterestsCollectionViewCell, with viewModel: InterestViewModel) {
        cell.interestImage.image = viewModel.interestImage
        cell.interestLabel.text = viewModel.interestName
        
        if viewModel.hasNewStatus {
            cell.addBorder()
        } else {
            cell.removeBorder()
        }
    }
}
