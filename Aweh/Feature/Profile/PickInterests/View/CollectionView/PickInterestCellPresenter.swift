//
//  PickInterestCellPresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/07/05.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

class PickInterestCellPresenter {
    func configure(_ cell: PickInterestCollectionViewCell, forDisplaying model: InterestViewModel) {
        // TODO: Remove this / subscribed or not
        let buttonTitle = true ? "Subscribe" : "Subscribed" // TODO: change
        cell.action = {
            cell.addToInterest.setTitle(buttonTitle, for: .normal)
        }
        cell.interestName.text = model.interestName
        cell.addToInterest.setTitle(buttonTitle, for: .normal)
        
        cell.roundCorner()
    }
}
