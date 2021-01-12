//
//  Date+Element.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/20.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

extension Date {
     func relativeDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale.current
        dateFormatter.doesRelativeDateFormatting = true
        return dateFormatter.string(from: self)
    }
    
    static func fromString(string: String?) -> Date {
        guard let string = string, let timeAsDouble = Double(string)
        else {
            preconditionFailure("Could not parse string date to Date")
        }
        return Date(timeIntervalSince1970: timeAsDouble)
    }
}
