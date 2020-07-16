//
//  StatusCellPresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/06.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

class FeedCellPresenter {
    func configure(with cell: FeedCollectionViewCell, forDisplaying model: StatusViewModel) {
        cell.userName.text = model.userName // change this to attributed string
        cell.statusText.attributedText = model.status
        cell.distanceAndTime.text = model.distanceFromYou + "KM・\(model.timeSincePosted)" // change this to attributed string
        
        if model.statusImage == nil {
            cell.statusImage.isHidden = true
        } else {
            cell.statusImage.image = model.statusImage
        }
        
//        cell.setNeedsLayout()
//        cell.layoutIfNeeded()
    }
    
    func didSelectItem(viewModel: StatusViewModel) {
        // TODO: - some logic when the cell is selected
    }
}
