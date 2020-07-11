//
//  UIView+Elements.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/09.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

extension UIView {
    func makeRound() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.height / 2
    }
    
    func makeImageRound() {
        makeRound()
        contentMode = .scaleAspectFill
        layer.borderWidth = 0.03
        layer.backgroundColor = UIColor.systemGray6.cgColor
    }
}

extension UIView {
    
    /// if you add a border to all sides, call without params
    func addDividerLine(applyTo sides: [UIRectEdge] = []) {
        var newSides = sides
        if newSides.isEmpty || newSides == [.all] {
            newSides = [.top, .left, .bottom, .right]
        }
        newSides.forEach { side in
            applyBorder(toSide: side)
        }
    }
    
    private func applyBorder(toSide: UIRectEdge) {
        let borderView = UIView()
        addSubview(borderView)
        borderView.translatesAutoresizingMaskIntoConstraints = false
       
        switch toSide {
            case .bottom:
                borderView.topAnchor --> bottomAnchor
                borderView.widthAnchor --> widthAnchor
                borderView.heightAnchor --> 1
            case .top:
                borderView.bottomAnchor --> topAnchor
                borderView.widthAnchor --> widthAnchor
                borderView.heightAnchor --> 1
            case .left:
                borderView.heightAnchor --> heightAnchor
                borderView.widthAnchor --> 1
                borderView.trailingAnchor --> leadingAnchor
            case .right:
                borderView.heightAnchor --> heightAnchor
                borderView.widthAnchor --> 1
                borderView.leadingAnchor --> trailingAnchor
            default:
                break
        }
        
    }
}
