//
// Created by Divine.Dube on 2020/08/25.
// Copyright (c) 2020 com.github.aweh. All rights reserved.
//

import Foundation

protocol DateValueCodingStrategy {
    associatedtype RawValue: Codable, Hashable

    static func decode(_ value: RawValue) throws -> Date
    static func encode(_ date: Date) -> RawValue
}

@propertyWrapper
struct DateValue<Formatter: DateValueCodingStrategy>: Codable, Hashable {
    
    private let value: Formatter.RawValue
    var wrappedValue: Date

    init(wrappedValue: Date) {
        self.wrappedValue = wrappedValue
        self.value = Formatter.encode(wrappedValue)
    }

    public init(from decoder: Decoder) throws {
        self.value = try Formatter.RawValue(from: decoder)
        self.wrappedValue = try Formatter.decode(value)
    }

    func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }
}
