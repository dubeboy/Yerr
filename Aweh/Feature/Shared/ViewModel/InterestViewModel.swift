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
}

extension InterestViewModel {
    static func transform(from interest: Interest) -> InterestViewModel {
        InterestViewModel(interestName: interest.name)
    }
}
