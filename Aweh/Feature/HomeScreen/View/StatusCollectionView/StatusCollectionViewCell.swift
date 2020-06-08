//
//  HomeScreenCollectionViewCell.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/03.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class StatusCollectionViewCell: UICollectionViewCell {
    
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
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        attributes.frame.size = calculateFrame()
        return attributes
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
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.contentMode = .scaleAspectFill
    }
}
