//
//  Common+Elements.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/07/04.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation
import UIKit

// MARK: Keyboard
func keyboardFrame(from notification: NSNotification) -> CGRect? {
    guard let userInfo = notification.userInfo else { return nil }
    guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
        as? NSValue else { return nil }
    return keyboardSize.cgRectValue
}


