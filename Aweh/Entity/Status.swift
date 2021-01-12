//
// Created by Divine.Dube on 2020/08/26.
// Copyright (c) 2020 com.github.aweh. All rights reserved.
//

import Foundation

struct Status: Codable {
    var id: String? = nil
    let body: String
    let user: User
    @DefaultEmptyArray
    var comments: [Comment]
    let location: Location
    @DefaultEmptyArray
    var media: [Media]
    let likes, votes: Int
    @DateValue<ISO8601Strategy>
    var createdAt: Date
}