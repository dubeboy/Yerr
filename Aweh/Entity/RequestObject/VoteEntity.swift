//
//  StatusVote.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/09/21.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

struct VoteEntity: Codable {
    let id: UserEntityID
    var direction: Bool? = nil
}
