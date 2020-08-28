//
// Created by Divine.Dube on 2020/08/25.
// Copyright (c) 2020 com.github.aweh. All rights reserved.
//

import Foundation

struct ISO8601Strategy: DateValueCodingStrategy {
    static func decode(_ value: String) throws -> Date {
        guard let date = ISO8601DateFormatter().date(from: value) else {
            // TODO:we should log this error when thrown at run time!!!
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Invalid Date Format!"))
        }
    
        return date
    }

    static func encode(_ date: Date) -> String {
        ISO8601DateFormatter().string(from: date)
    }
}
