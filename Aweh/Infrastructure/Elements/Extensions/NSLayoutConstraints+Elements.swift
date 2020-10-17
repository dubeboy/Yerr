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
precedencegroup NSLayoutPrecedence {
    higherThan: AdditionPrecedence
    associativity: left
}

infix operator -->: NSLayoutPrecedence
infix operator +: AdditionPrecedence // Change this so can have a proper precedence for addition
//infix operator +
//infix operator <-- --<= -->=

//use tenary ops
//bar --> statusIndicatorView { statusView, bar in
//
//}



func -->(lhs: UIView, rhs: UIView) { // wanna also be able to do somthing like v -> v2 + 16
    lhs.translatesAutoresizingMaskIntoConstraints = false
    lhs.leadingAnchor --> rhs.leadingAnchor
    lhs.trailingAnchor --> rhs.trailingAnchor
    lhs.topAnchor --> rhs.topAnchor
    lhs.bottomAnchor --> rhs.bottomAnchor
}


@discardableResult
func -->(lhs: NSLayoutXAxisAnchor, rhs: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
    let contraint = lhs.constraint(equalTo: rhs)
    contraint.isActive = true
    return contraint
}

@discardableResult
func -->(lhs: NSLayoutYAxisAnchor, rhs: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
    let contraint = lhs.constraint(equalTo: rhs)
    contraint.isActive = true
    return contraint
}

func -->(lhs: NSLayoutDimension, rhs: CGFloat) {
    lhs.constraint(equalToConstant: rhs).isActive = true
}

func -->(lhs: NSLayoutDimension, rhs: NSLayoutDimension) {
    lhs.constraint(equalTo: rhs).isActive = true
}

func +(lhs: NSLayoutConstraint, rhs: CGFloat) {
    lhs.constant = rhs
}

// Use currying to make this better
// https://thoughtbot.com/blog/introduction-to-function-currying-in-swift
// https://www.reddit.com/r/swift/comments/2fjwav/custom_ternary_operator/
//func --><LHS: UIView, RHS: UIView>(lhs:  LHS, apply: (LHS) -> RHS) -> RHS {
//    apply(lhs)
//}


// looks nice but too verbose!!!
//func --><RHS: UIView, LHS: UIView>(lhs: (left: RHS, right: LHS), apply: (RHS, LHS) -> Void) {
//     lhs.left.translatesAutoresizingMaskIntoConstraints = false
//     apply(lhs.left, lhs.right)
//}

//func -->(lhs: NSLayoutDimension, rhs: NSLayoutDimension) {
//    lhs.constraint(equalToConstant: rhs).isActive = true
//} A --> B + 8 to add a constant




