//
// Created by Divine.Dube on 2020/08/26.
// Copyright (c) 2020 com.github.aweh. All rights reserved.
//

import Foundation

struct StatusResponseEntity<T: Codable>: Codable {
    let status: Bool
    let message: String
    let entity: T?
}
