//
// Created by Divine.Dube on 2020/08/26.
// Copyright (c) 2020 com.github.aweh. All rights reserved.
//

import Foundation

struct Media: Codable {

    enum MediaType: Int, Codable {
        case video, picture, none = -1
    }

    let name: String
    @DefaultMinusOneIntEnum
    var type: MediaType
    let location: String
    @DateValue<ISO8601Strategy>
    var createAt: Date
    var size: UInt
}