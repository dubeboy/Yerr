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
    let userImage: String // TODO change this to imageLink
    let userName: String // TODO: change to name
    let statuses: [StatusViewModel] // TODO: remove these
    let point: GuageViewViewModel?
}

extension UserViewModel {
    static func transform(user: User) -> UserViewModel {
        UserViewModel(
            userImage: user.id ?? "",
            userName: user.name,
            statuses: [],
            point: nil  // TODO: look into this please
        )
    }
}
