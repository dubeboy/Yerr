//
// Created by Divine.Dube on 2020/08/25.
// Copyright (c) 2020 com.github.aweh. All rights reserved.
//

import Foundation

// TODO: If some things failes to decode we want to log it

protocol DefaultCodableStrategy {
    associatedtype RawValue: Codable

    static var defaultValue: RawValue { get }
}

@propertyWrapper
struct DefaultCodable<Default: DefaultCodableStrategy>: Codable {
    var wrappedValue: Default.RawValue

    init(wrappedValue: Default.RawValue) {
        self.wrappedValue = wrappedValue
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.wrappedValue = (try? container.decode(Default.RawValue.self)) ?? Default.defaultValue
    }

    func encode(to encoder: Encoder) throws {
        try  wrappedValue.encode(to: encoder)
    }
}

extension DefaultCodable: Equatable where Default.RawValue: Equatable {}
extension DefaultCodable: Hashable where Default.RawValue: Hashable {}


extension KeyedDecodingContainer {
    func decode<P>(_: DefaultCodable<P>.Type, forKey key: Key) throws -> DefaultCodable<P> {
       if let value = try decodeIfPresent(DefaultCodable<P>.self, forKey: key) {
           return value
       } else {
           return DefaultCodable(wrappedValue: P.defaultValue)
       }
    }
}
