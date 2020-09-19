//
//  Logger.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/07/11.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

// TODO: look into OSLogger
// TODO: Log these errors to our analytics engine our own analytics engine maybe?
enum Logger {
    static func log(_ error: Error) {
        #if DEBUG
            print(error)
        #endif
    }
    
    static func log(_ error: String) {
        #if DEBUG
            print(error)
        #endif
    }
    
    /**
        this outputs to the console and it does not report an error
     */
    static func i(_ info: String) {
        #if DEBUG
            print("🚨 XXX ❌")
            print(info)
            print("❌ XXX 🚨")
        #endif
    }
    
    static func i(_ info: Error) {
        #if DEBUG
        print("❌ XXX 🚨")
        print(info)
        print("❌ XXX 🚨")
        #endif
    }
    
    static func i(_ info: Any) {
        Self.i(String(describing: info))
    }
    
    static func wtf(_ thisShouldNotHappen: String) {
        Self.log(thisShouldNotHappen)
    }
    
}


