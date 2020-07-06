//
//  InterestsViewModel.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/24.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation
import UIKit

// TODO: singularize
struct InterestViewModel {
    let interestName: String
    let hasNewStatus: Bool
    private(set) var interestImage: UIImage? = nil
    let users: [UserViewModel]
}

extension InterestViewModel {
    static func transform(from interest: Interest) -> InterestViewModel {
        return InterestViewModel(
            interestName: interest.interestName,
            hasNewStatus: interest.hasNewStatus,
            interestImage: UIImage(named: interest.interestImageLink),
            users: interest.users.map(UserViewModel.transform(user:))
        )
    }
}
