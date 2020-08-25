//
// Created by Divine.Dube on 2020/08/25.
// Copyright (c) 2020 com.github.aweh. All rights reserved.
//

import Foundation

struct DefaultEmptyArray<T: Codable>: DefaultCodableStrategy {
    static var defaultValue: [T] { [] }
}
