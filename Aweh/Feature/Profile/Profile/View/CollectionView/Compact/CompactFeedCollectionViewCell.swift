//
//  CompactFeedCollectionViewCell.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/07/15.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class CompactFeedCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var compactBackGroundView: UIVisualEffectView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        roundCorners()
        subviews.forEach { s in
            s.translatesAutoresizingMaskIntoConstraints = false
        }
        
    }
    
    private func roundCorners() {
        layer.masksToBounds = true
        layer.cornerRadius = Const.View.radius
    }

}
