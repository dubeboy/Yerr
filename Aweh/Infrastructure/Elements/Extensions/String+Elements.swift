//
//  String+Elements.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/07/21.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

extension String {
    static func error(_ message: String?) -> String {
        if let message = message {
            return message
        }
        return AppStrings.Common.genericError
    }
}
