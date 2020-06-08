//
//  HomeScreenViewModel.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/03.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

struct HomeScreenStatusViewModel {
    let status: String
    let image: UIImage?
    let profilePicture: UIImage
    let dateInReadableFormat: String
    let distanceFromYou: String
}

extension HomeScreenStatusViewModel {
    static func createHomeScreenViewModel(status: String, image: UIImage?, profilePicture: UIImage, dateInReadableFormat: String, distanceFromYou: String) -> HomeScreenStatusViewModel {
        
        return HomeScreenStatusViewModel(
            status: status,
            image: image,
            profilePicture: profilePicture,
            dateInReadableFormat: dateInReadableFormat,
            distanceFromYou: distanceFromYou
        )
    }
}
