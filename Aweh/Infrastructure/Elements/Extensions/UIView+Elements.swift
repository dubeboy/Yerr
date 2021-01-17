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
        layer.backgroundColor = Const.Color.lightGray.cgColor
    }
}

extension UIView {
    func autoresizingOff() {
        self.translatesAutoresizingMaskIntoConstraints = false
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
    // TODO: check with juts adding border layer!!
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
    func addShadow(offest: CGFloat = 2.0, color: UIColor = UIColor.gray) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: offest, height: offest)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
    }
}

// Confetti!!! commented out because its not being used!!!

extension UIView {
//    private func addConfetti(to layer: CALayer) {
//        let images: [UIImage] = (0...5).map { UIImage(named: "confetti\($0)")! }
//        let colors: [UIColor] = [.systemGreen, .systemRed, .systemBlue, .systemPink, .systemOrange, .systemPurple, .systemYellow]
//        let cells: [CAEmitterCell] = (0...16).map { i in
//            let cell = CAEmitterCell()
//            cell.contents = images.randomElement()?.cgImage
//            cell.birthRate = 3
//            cell.lifetime = 12
//            cell.lifetimeRange = 0
//            cell.velocity = CGFloat.random(in: 100...200)
//            cell.velocityRange = 0
//            cell.emissionLongitude = 0
//            cell.emissionRange = 0.8
//            cell.spin = 4
//            cell.color = colors.randomElement()?.cgColor
//            cell.scale = CGFloat.random(in: 0.2...0.8)
//            return cell
//        }
//
//        let emitter = CAEmitterLayer()
//        emitter.emitterPosition = CGPoint(x: layer.frame.size.width / 2, y: layer.frame.size.height + 5)
//        emitter.emitterShape = .line
//        emitter.emitterSize = CGSize(width: layer.frame.size.width, height: 2)
//        emitter.emitterCells = cells
//
//        layer.addSublayer(emitter)
//    }
}

// MARK: - Find first responder

extension UIView {
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }
        
        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }
        
        return nil
    }
}

// MARK : - shrinkView

//extension UIView {
//    func shrink(down: Bool) {
//        UIView.animate(withDuration: 0.6) {
//            if down {
//                cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//            else {
//                    cell.transform = .identity
//            }
//          }
//        }
//}
