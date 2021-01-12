//
//  User.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/09/22.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

protocol UserInteractor {
    var currentUser: User { get }
}

class UserInteractorImplementation: UserInteractor {
    var currentUser: User = User.dummyUser
}
