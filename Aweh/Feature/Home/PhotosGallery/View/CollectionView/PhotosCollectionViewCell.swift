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
        imageIsSelected.image = nil
        imageIsSelected.contentMode = .scaleAspectFill
        imageIsSelected.tintColor = Const.Color.PhotoGallery.photoGallery
        imageView.contentMode = .scaleAspectFill
        viewOverlay.isHidden = true
        timeLabel.font = .boldSystemFont(ofSize: 12) // TODO: Font
        contentView.bringSubviewToFront(timeLabel)
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                imageIsSelected.image = Const.Assets.PhotoGallery.imageSelectedMark
                imageIsSelected.isHidden = false
            } else {
                imageIsSelected.isHidden = true
            }
           
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
        viewOverlay.isHidden = true
        viewOverlay.backgroundColor = .clear
    }
}
