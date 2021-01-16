//
//  CGSize+Elements.swift
//  Aweh
//
//  Created by Divine.Dube on 2021/01/16.
//  Copyright © 2021 com.github.aweh. All rights reserved.
//

import UIKit

extension CGSize {
    func getAspectRatio() -> CGFloat {
        return self.height / self.width
    }
}
