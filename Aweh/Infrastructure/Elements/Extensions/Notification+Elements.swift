//
//  Notification+Elements.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/07/04.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation
import UIKit

extension Notification.Name {
    static let keyboardWillShow: Notification.Name = UIResponder.keyboardWillShowNotification
    static let keyboardDidShow: Notification.Name = UIResponder.keyboardDidShowNotification
    static let keyboardWillHide: Notification.Name = UIResponder.keyboardWillHideNotification
    static let keyboardDidHide: Notification.Name = UIResponder.keyboardDidHideNotification
    static let keyboardWillChangeFrame: Notification.Name = UIResponder.keyboardWillChangeFrameNotification
}
