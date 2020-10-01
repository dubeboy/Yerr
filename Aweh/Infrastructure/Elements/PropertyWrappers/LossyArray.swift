//
// Created by Divine.Dube on 2020/08/25.
// Copyright (c) 2020 com.github.aweh. All rights reserved.
//

import Foundation

// http://marksands.github.io/2019/10/21/better-codable-through-property-wrappers.html
@propertyWrapper
struct LossyArray<T: Codable> {

    private struct AnyDecodableValue: Codable {}

    private struct LossyDecodableValue<V: Codable>: Codable {
        let value: V

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            value = try container.decode(V.self)
        }
    }

    var wrappedValue: [T]

    init(wrappedValue: [T])  {
        self.wrappedValue = wrappedValue
    }

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer() // we are decoding an array
        var elements: [T] = []

        while !container.isAtEnd {
            do {
                let value = try container.decode(LossyDecodableValue<T>.self).value
                elements.append(value)
            } catch {
                _ = try? container.decode(AnyDecodableValue.self) // so that it continues
            }

        }
        self.wrappedValue = elements
    }

    func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}
