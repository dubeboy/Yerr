//
//  LateInit.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/07/07.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

// TODO: to be implemented
@propertyWrapper
struct LateInit<T> {
    var wrappedValue: T?
    
    init(value: T? = nil) {
        self.wrappedValue = value
    }
    
    var isInitialized: Bool {  wrappedValue != nil }
}
