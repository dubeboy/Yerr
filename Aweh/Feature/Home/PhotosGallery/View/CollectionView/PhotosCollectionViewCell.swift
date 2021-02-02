//
//  PhotosCollectionViewCell.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/10.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewOverlay: UIView!
    @IBOutlet weak var imageIsSelected: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    var representationItemIndetifier: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageIsSelected.image = Const.Assets.PhotoGallery.imageSelectedMark
        imageIsSelected.contentMode = .scaleAspectFill
        imageIsSelected.tintColor = Const.Color.PhotoGallery.photoGallery
        imageView.contentMode = .scaleAspectFill
        viewOverlay.isHidden = true
        timeLabel.font = .boldSystemFont(ofSize: 12)
        contentView.bringSubviewToFront(timeLabel)
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                imageIsSelected.isHidden = false
            } else {
                imageIsSelected.isHidden = true
            }
           
        }
    }
}
