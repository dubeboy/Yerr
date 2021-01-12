//
// Created by Divine.Dube on 2020/08/26.
// Copyright (c) 2020 com.github.aweh. All rights reserved.
//

import Foundation

struct Flagged: Codable {
    var flagged: Bool = true
    var reason: String = "" // TODO: could be an enum
}
