//
// Created by Divine.Dube on 2020/08/25.
// Copyright (c) 2020 com.github.aweh. All rights reserved.
//

import Foundation

struct DefaultMinusOneIntEnumStrategy<T: Codable>: DefaultCodableStrategy where T: RawRepresentable , T.RawValue == Int {
    static var defaultValue: T {
       guard let value = T.init(rawValue: -1)  else {
           // TODO: log error here this should never happen
           preconditionFailure("Client side programmer error: Failed to convert DefaultMinusOneIntEnum make sure you enum has case value of -1")
       }
        return value
    }
}

typealias DefaultMinusOneIntEnum<T: Codable> = DefaultCodable<DefaultMinusOneIntEnumStrategy<T>> where T: RawRepresentable , T.RawValue == Int
