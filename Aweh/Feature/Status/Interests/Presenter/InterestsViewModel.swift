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
    var interestImage: UIImage? = nil
}

extension InterestViewModel {
    static func transform(from interest: Interest) -> InterestViewModel {
        return InterestViewModel(interestName: interest.interestName, hasNewStatus: interest.hasNewStatus, interestImage: UIImage(named: interest.interestImageLink))
    }
}
