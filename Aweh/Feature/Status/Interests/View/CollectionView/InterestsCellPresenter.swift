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
        cell.interestsContainerView.children = viewModel.interestName
    }
}
