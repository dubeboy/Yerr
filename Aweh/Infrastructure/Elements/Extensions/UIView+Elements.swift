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
    func addDividerLine(to sides: [UIRectEdge] = []) {
        var newSides = sides
        if newSides.isEmpty || newSides == [.all] {
            newSides = [.top, .left, .bottom, .right]
        }
        newSides.forEach { side in
            applyBorder(toSide: side)
        }
    }
    
    // TODO: ability to add insets 
    private func applyBorder(toSide: UIRectEdge) {
        let borderView = UIView()
        borderView.backgroundColor = Const.Color.lightGray
        addSubview(borderView)
        borderView.translatesAutoresizingMaskIntoConstraints = false
       
        //TODO: inconplete swap constraints or increase size by 1
        switch toSide {
            case .bottom:
                borderView.topAnchor --> bottomAnchor
                borderView.widthAnchor --> widthAnchor
                borderView.leadingAnchor --> leadingAnchor
                borderView.trailingAnchor --> trailingAnchor
                borderView.heightAnchor --> 1
            case .top:
                borderView.bottomAnchor --> topAnchor
                borderView.widthAnchor --> widthAnchor
                borderView.leadingAnchor --> leadingAnchor
                borderView.trailingAnchor --> trailingAnchor
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


extension UIView {
    func shadow() {
//        self.contentView.layer.cornerRadius = 2.0
//        self.contentView.layer.borderWidth = 1.0
//        self.contentView.layer.borderColor = UIColor.clear.cgColor
//        self.contentView.layer.masksToBounds = true
//        
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        self.layer.shadowRadius = 2.0
//        self.layer.shadowOpacity = 0.5
//        self.layer.masksToBounds = false
//        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
}
