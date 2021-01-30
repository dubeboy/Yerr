//
//  PhotosCollectionViewCell.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/10.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageIsSelected: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    var representationItemIndetifier: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageIsSelected.image = Const.Assets.PhotoGallery.imageSelectedMark
        imageIsSelected.contentMode = .scaleAspectFill
        imageIsSelected.tintColor = Const.Color.PhotoGallery.photoGallery
        imageView.contentMode = .scaleAspectFill
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
