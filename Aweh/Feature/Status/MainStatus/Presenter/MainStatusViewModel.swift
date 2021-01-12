//
//  MainStatusViewModel.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/07/13.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

struct RepliesViewModel {}

enum MainStatusViewModelSelection {
    case interests(InterestViewModel)
    case replies(RepliesViewModel)
}

struct MainStatusViewModel {
    let interests: InterestViewModel
    let replies: RepliesViewModel
}
