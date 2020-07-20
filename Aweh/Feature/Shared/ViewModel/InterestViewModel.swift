//
//  InterestsViewModel.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/24.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation
import UIKit

struct InterestViewModel: Hashable {
    let interestName: String
    let hasNewStatus: Bool
    private(set) var interestImage: String? = nil
    let users: [UserViewModel]
}

extension InterestViewModel {
    static func transform(from interest: Interest) -> InterestViewModel {
        return InterestViewModel(
            interestName: interest.title,
            hasNewStatus: false,
            interestImage: "",
            users: []
        )
    }
}
