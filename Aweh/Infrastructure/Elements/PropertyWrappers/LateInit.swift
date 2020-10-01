//
//  LateInit.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/07/07.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

@propertyWrapper
struct LateInit<T> {

    var storage: T?
    var wrappedValue: T {
        get {
           guard let storage = storage else {
               let errorMessage = "Trying to access LateInit value before setting it."
               Logger.log(errorMessage)
               preconditionFailure(errorMessage)
           }
            return storage
        }
        set {
            storage = newValue
        }
    }
    
    init() {
        storage = nil
    }
    
    var projectedValue: Self { self }

    var isInitialized: Bool {  storage != nil }
    
    mutating func release() {
        self.storage = nil
    }
}

class J {

    @LateInit
    var s: Int

    func sss() {
        print(s)
    }
}
