//
// Created by Divine.Dube on 2020/08/26.
// Copyright (c) 2020 com.github.aweh. All rights reserved.
//

import Foundation

struct User: Codable {
    var id: String?
    let name: String
    let handle: String
    let phoneNumber: String
    let profilePicture: Media?
    let point: Point
}

extension User {
    static let dummyUser = User(id: "60000", name: "User100", handle: "aweee", phoneNumber: "089898888", profilePicture: nil, point: Point(score: 0, badge: ""))
}

struct Point: Codable {
    let score: Int
    let badge: String
}
