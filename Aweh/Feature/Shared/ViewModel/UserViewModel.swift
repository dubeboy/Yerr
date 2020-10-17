//
//  UserViewModel.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/28.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation
import UIKit


struct PointsViewModel: Hashable {
    let score: Int
    let badge: String
    let color: String
}

struct UserViewModel: Hashable {
    let profilePicture: String // TODO change this to imageLink
    let name: String
    let point: PointsViewModel?
    var statuses: [StatusViewModel] = []
}

extension UserViewModel {
    static func transform(user: User) -> Self {
        UserViewModel(
            profilePicture: user.profilePicture?.location ?? "",
            name: user.name,
            point: nil
        )
    }
}

extension User {
    static func transform(user: UserViewModel) -> Self {
        User(id: nil, name: user.name, handle: "", phoneNumber: "", profilePicture:
                Media(name: "",
                      type: .picture,
                      location: "",
                      createAt: Date(),
                      size: 0),
             point: Point(score: 0, badge: ""))
    }
}
