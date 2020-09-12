//
//  DetailCommentViewModel.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/20.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

struct Comment: Codable {
    let body: String
    let user: User
    @DefaultEmptyArray
    var media: [Media]
    @DateValue<ISO8601Strategy>
    var createdAt: Date
    var votes: Int = 0
    var likes: Int = 0
    let location: Location
    // TODO: create a nullable passback prop wrap so we can remove the `?`
    let id: String?
}

