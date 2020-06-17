//
//  NSLayoutConstraints+Elements.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/04.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit
// you can use somthig like apply here
// contraints --> 7
// leading adges -| view or |-
infix operator -->
//infix operator <-- --<= -->=

func -->(lhs: UIView, rhs: UIView) {
    lhs.translatesAutoresizingMaskIntoConstraints = false
    rhs.translatesAutoresizingMaskIntoConstraints = false
    lhs.leadingAnchor --> rhs.leadingAnchor
    lhs.trailingAnchor --> rhs.trailingAnchor
    lhs.topAnchor --> rhs.topAnchor
    lhs.bottomAnchor --> rhs.bottomAnchor
}

func -->(lhs: NSLayoutXAxisAnchor, rhs: NSLayoutXAxisAnchor) {
    lhs.constraint(equalTo: rhs).isActive = true
}

func -->(lhs: NSLayoutYAxisAnchor, rhs: NSLayoutYAxisAnchor) {
    lhs.constraint(equalTo: rhs).isActive = true
}

func -->(lhs: NSLayoutDimension, rhs: CGFloat) {
    lhs.constraint(equalToConstant: rhs).isActive = true
}

//func -->(lhs: NSLayoutDimension, rhs: NSLayoutDimension) {
//    lhs.constraint(equalToConstant: rhs).isActive = true
//}



