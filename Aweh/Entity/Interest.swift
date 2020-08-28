//
// Created by Divine.Dube on 2020/08/28.
// Copyright (c) 2020 com.github.aweh. All rights reserved.
//

import Foundation

struct Interest: Codable {
    let name: String
    let hasNewStatus: Bool
    @DefaultEmptyArray
    var topPeopleImages: [Media] // TODO: If its empty then we just create an image using the name
    let isSubscribed: Bool
}
