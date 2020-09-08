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
        cell.userName.text = model.user.name // change this to attributed string
        cell.statusText.text = model.status
        cell.distanceAndTime.text = model.distanceFromYou + "KM・\(model.timeSincePosted)" // change this to attributed string
        
//        if model.media.isEmpty {
//            cell.statusImage.isHidden = true
//        } else {
//            model.media.forEach { media in
//                cell.statusImage.downloadImage(fromUrl: media.location)
//            }
//        }
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
    }
    
    func didSelectItem(viewModel: StatusViewModel) {
        // TODO: - some logic when the cell is selected
    }
}
