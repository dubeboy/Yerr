//
//  FeedDetailCollectionViewCell.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/17.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class FeedDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView! {
        didSet {
            userImage.contentMode = .scaleAspectFill
            userImage.makeImageRound()
        }
    }
    @IBOutlet weak var mediaCollectionView: UICollectionView!
    
    @IBOutlet weak var statusText: UILabel! {
        didSet {
            statusText.numberOfLines = 0
            statusText.lineBreakMode = .byWordWrapping
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        configureContentView()
       
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let contentViewSize = contentView.bounds
        let size = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let attr = super.preferredLayoutAttributesFitting(layoutAttributes)
        let newSize = CGSize(width: contentViewSize.width, height: size.height)
        var newFrame = attr.frame

        newFrame.size = newSize
        attr.frame = newFrame
        return attr
    }

}
