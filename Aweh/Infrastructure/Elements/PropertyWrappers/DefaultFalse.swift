//
// Created by Divine.Dube on 2020/08/25.
// Copyright (c) 2020 com.github.aweh. All rights reserved.
//

import Foundation

struct DefaultFalseStrategy: DefaultCodableStrategy {
    static var defaultValue: Bool { false }
}

typealias DefaultFalse = DefaultCodable<DefaultFalseStrategy>
