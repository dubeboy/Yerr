//
//  InterestsCollectionViewCell.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/24.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class InterestsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var interestImage: UIImageView! {
        didSet {
            interestImage.clipsToBounds = true
            interestImage.contentMode = .scaleAspectFill
            interestImage.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var imageView: UIView! {
        didSet {
            addBlurEffects(for: imageView)
        }
    }
    
    @IBOutlet weak var interestLabel: UILabel! {
        didSet {
            interestLabel.textColor = .label
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        layer.cornerRadius = bounds.width / 4 // TODO: - Effeted buy number of columns
        contentView.layer.cornerRadius = 10
    }
   
    func addBorder() {
//         add a dashed line
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    func removeBorder() {
        contentView.layer.borderWidth = 0
    }
    
    func addBlurEffects(for view: UIView) {
        let blurEffect = UIBlurEffect(style: .systemThinMaterialLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.clipsToBounds = true
//        blurEffectView.alpha = 0.7
        blurEffectView.layer.cornerRadius = 10
        blurEffectView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        view.insertSubview(blurEffectView, at: 0)
        blurEffectView --> view
    }
}
