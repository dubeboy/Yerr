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
    let profilePicture: String // TODO change this to imageLink
    let name: String
    let point: GuageViewViewModel?
}

extension UserViewModel {
    static func transform(user: User) -> UserViewModel {
        UserViewModel(
            profilePicture: user.profilePicture?.location ?? "",
            name: user.name,
            point: nil
        )
    }
}
