//
//  InterestsCollectionViewCell.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/24.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class InterestsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var imageLeadingContraint: NSLayoutConstraint!
    @IBOutlet weak var imageTopContraint: NSLayoutConstraint!
    @IBOutlet weak var imageTrailingContraint: NSLayoutConstraint!
    @IBOutlet weak var imageCheck: UIImageView! {
        didSet {
            imageCheck.tintColor = .systemBlue
        }
    }

    @IBOutlet weak var interestImage: UIImageView! {
        didSet {
            interestImage.clipsToBounds = true
            interestImage.contentMode = .scaleAspectFill
            interestImage.layer.cornerRadius = 10
        }
    }
    
    
    override var isSelected: Bool {
        didSet {
            changeViewAppearence(on: isSelected)
        }
    }
    
    private func changeViewAppearence(on isSelected: Bool) {
        if isSelected {
            UIView.animate(withDuration: 0.5) { [self] in
                imageCheck.image = Const.Assets.Interests.iconCheckmark
                modify(constaint: Const.View.m16)
            }
        } else {
            UIView.animate(withDuration: 0.5) { [self] in
                imageCheck.image = nil
                modify(constaint: Const.View.m8)
            }
        }
    }
    
    private func modify(constaint constant: CGFloat) {
        imageTopContraint.constant = constant
        imageBottomContraint.constant = constant
        imageTrailingContraint.constant = constant
        imageLeadingContraint.constant = constant
    }
    
    @IBOutlet weak var imageView: UIView! {
        didSet {
            let visualEffectView = addBlurVisualEffect(for: imageView)
            visualEffectView.layer.cornerRadius = 10
            visualEffectView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            visualEffectView.alpha = 0.7
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
    
    func addBlurVisualEffect(for view: UIView) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: .systemThinMaterialLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.clipsToBounds = true
        view.insertSubview(blurEffectView, at: 0)
        blurEffectView --> view
        return blurEffectView
    }
}
