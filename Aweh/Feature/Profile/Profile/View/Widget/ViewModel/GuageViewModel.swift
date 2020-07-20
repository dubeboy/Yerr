//
//  GuageViewModel.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/07/10.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

struct GuageViewViewModel: Hashable {
    let values: [Int]
    var count: Int {
        values.count
    }
}

extension GuageViewViewModel {
    static func transform(point: Profile) -> GuageViewViewModel? {
//        guard let point = point else { return nil }
//        return GuageViewViewModel(values: point.scores)
        return nil
    }
}
