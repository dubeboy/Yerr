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
    let colorHex: String
}

extension PointsViewModel {
    static func transform(point: Point) -> Self {
        PointsViewModel(score: point.score, badge: point.badge, colorHex: point.colorHex)
    }
}

struct UserViewModel: Hashable {
    let profilePicture: String // TODO change this to imageLink
    let name: String
    let point: PointsViewModel
    var statuses: [StatusViewModel] = []
}

extension UserViewModel {
    static func transform(user: User) -> Self {
        UserViewModel(
            profilePicture: user.profilePicture?.location ?? "",
            name: user.name,
            point: .transform(point: user.point)
        )
    }
}

extension User {
    // TODO: need to set values that can be nil nil here
    static func transform(user: UserViewModel) -> Self {
        User(id: nil, name: user.name, handle: "", phoneNumber: "", profilePicture:
                Media(name: "",
                      type: .picture,
                      location: "",
                      createAt: Date(),
                      size: 0),
             point: Point(score: 0, badge: "", colorHex: ""))
    }
}
