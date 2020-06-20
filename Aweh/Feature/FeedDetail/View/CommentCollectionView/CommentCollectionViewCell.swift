//
//  CommentCollectionViewCell.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/19.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class CommentCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView! {
        didSet {
            userProfileImage.makeImageRound()
        }
    }
    @IBOutlet weak var commentText: UILabel! {
        didSet {
            commentText.numberOfLines = 0
            commentText.lineBreakMode = .byWordWrapping
        }
    }
    @IBOutlet weak var userName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
