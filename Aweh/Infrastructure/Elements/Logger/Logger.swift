//
//  Logger.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/07/11.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

// TODO: look into OSLogger
// TODO: Log these errors to our analytics engine
enum Logger {
    static func log(_ error: Error) {
        #if DEBUG
            print(error)
        #endif
    }
}


