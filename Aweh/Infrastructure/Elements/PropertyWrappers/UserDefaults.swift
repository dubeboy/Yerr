//
//  UserDefaults.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/10/17.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

extension UserDefaults {
    /// Helps facilitate testing and sharing data between apps
    static var shared: UserDefaults {
        let combined = UserDefaults.standard
        combined.addSuite(named: "com.dubedivine.yerr.shared")
        return combined
    }
}

private protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
}

struct UserDefaultsBacked<T> {
    let key: AppStrings.Shared.UserDefaults
    let defaultValue: T
    var storage: UserDefaults = .shared
    
    var wrappedValue: T {
        get {
            let value = storage.value(forKey: key.rawValue) as? T
            return value ?? defaultValue
        }
        set {
            if let optional = newValue as? AnyOptional, optional.isNil {
                storage.removeObject(forKey: key.rawValue)
            } else {
                storage.setValue(newValue, forKey: key.rawValue)
            }
        }
    }
}

extension UserDefaultsBacked where T: ExpressibleByNilLiteral {
    init(key:AppStrings.Shared.UserDefaults, storage: UserDefaults = .shared) {
        self.init(key: key, defaultValue: nil, storage: storage)
    }
}


