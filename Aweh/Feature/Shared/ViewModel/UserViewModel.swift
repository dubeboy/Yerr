//
//  UserViewModel.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/28.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation
import UIKit

struct UserViewModel: Hashable {
    let userImage: UIImage?
    let userName: String
    let statuses: [StatusViewModel]
    let point: GuageViewViewModel?
}

extension UserViewModel {
    static func transform(user: User) -> UserViewModel {
        UserViewModel(
            userImage: UIImage(named: user.profilePictureUrl),
            userName: user.name,
            statuses: user.statuses.map(StatusViewModel.transform(from:)),
            point: .transform(point: user.point)
        )
    }
}
