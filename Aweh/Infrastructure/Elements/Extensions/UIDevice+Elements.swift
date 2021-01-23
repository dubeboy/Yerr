//
//  UIDevice+Notch.swift
//  Aweh
//
//  Created by Divine.Dube on 2021/01/23.
//  Copyright © 2021 com.github.aweh. All rights reserved.
//

import UIKit

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
