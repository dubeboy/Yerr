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

extension StatusPageViewModel {
    static func transform(media: [Media], status: String) -> StatusPageViewModel {
        StatusPageViewModel(media: media.map(MediaViewModel.transform), status: status)
    }
}

