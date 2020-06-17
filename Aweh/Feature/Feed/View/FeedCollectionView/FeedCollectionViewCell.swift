//
//  HomeScreenCollectionViewCell.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/03.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var distanceAndTime: UILabel!
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        statusImage.contentMode = .scaleAspectFill
        configureCell()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
//
//         let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)

        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        var frame = attributes.frame
        frame.size.height = ceil(10)
        layoutAttributes.frame = frame
        return layoutAttributes
    }

    private func calculateFrame() -> CGSize {
        
        let imageHeight: CGFloat = statusImage.image == nil ? 0 : 150 // todo add these to global file
        let cellHeight = contentView.bounds.height + imageHeight + statusText.bounds.height + statusImage.bounds.height
        let size = CGSize(width: bounds.width, height: cellHeight)
    
       return size
    }
    
    private func configureContentView() {
        contentView.backgroundColor = .systemBackground
        contentView.clipsToBounds = true
    }
    
    private func configureCell() {
        configureContentView()
        configureProfileImage()
    }
    
    private func configureProfileImage() {
        profileImage.makeImageRound()
    }
}
