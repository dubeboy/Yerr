//
// Created by Divine.Dube on 2020/08/25.
// Copyright (c) 2020 com.github.aweh. All rights reserved.
//

import Foundation

struct ISO8601Strategy: DateValueCodingStrategy {
    static func decode(_ value: String) throws -> Date {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        guard let date = dateFormatter.date(from: value) else {
            // TODO:we should log this error when thrown at run time!!!
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Invalid Date Format!"))
        }
    
        return date
    }

    static func encode(_ date: Date) -> String {
        ISO8601DateFormatter().string(from: date)
    }

//    let fullISO8610Formatter = DateFormatter()
//        fullISO8610Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        fullISO8610Formatter.locale = Locale(identifier: "en_US_POSIX")
//        fullISO8610Formatter.timeZone = TimeZone(secondsFromGMT: 0)
//    let date = fullISO8610Formatter.date(from: str)!
}
