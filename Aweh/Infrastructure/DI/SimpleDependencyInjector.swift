//
//  SimpleDependencyInjector.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/04.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

// there should be registar

protocol RepositoryInjectable {
    init()
}

@propertyWrapper
struct InjectRepository<T> where T: RepositoryInjectable {
    var wrappedValue: T {
        T()
    }
}