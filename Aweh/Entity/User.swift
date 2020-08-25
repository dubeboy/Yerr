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
    let profilePicture: Media
    let point: Point
}

struct Point: Codable {
    let score: Int
    let badge: String
}