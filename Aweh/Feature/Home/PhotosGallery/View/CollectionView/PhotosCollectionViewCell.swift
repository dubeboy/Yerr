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
        imageView.contentMode = .scaleAspectFill
//        imageView.isUserInteractionEnabled = false
//        imageIsSelected.isUserInteractionEnabled = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(action1))
        imageView.addGestureRecognizer(tap)
    }
    
    @objc func action1() {
        Logger.i("tapped it!!!")
    }
    
    // move logic to presenter
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                imageIsSelected.backgroundColor = .blue
                imageIsSelected.isHidden = false
            } else {
                imageIsSelected.isHidden = true
            }
           
        }
    }
}
