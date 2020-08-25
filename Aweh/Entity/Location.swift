//
// Created by Divine.Dube on 2020/08/26.
// Copyright (c) 2020 com.github.aweh. All rights reserved.
//

import Foundation

struct Location: Codable {
    let lat, long: Double // TODO: SerializeName

    enum CodingKeys: String, CodingKey {
        case lat = "x"
        case long = "y"
    }
}