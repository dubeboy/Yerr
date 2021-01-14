//
//  StatusViewModel.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/23.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

struct StatusPageViewModel: Hashable {
    let media: [MediaViewModel]
    let status: String
    var backgroundColor: String = "" // should be a hex color
}

