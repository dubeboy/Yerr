//
//  HomeScreenCollectionViewCell.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/03.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var main: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var distanceAndTime: UILabel!
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var containerStackView: UIStackView!
    
    @LateInit
    var likeAndUpVoteHStack: LikeAndVotesHStask
    
    override func awakeFromNib() {
        super.awakeFromNib()
        likeAndUpVoteHStack = LikeAndVotesHStask()
        self.clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        configureContentView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        main.widthAnchor --> contentView.widthAnchor
        configureCell()
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
    
    private func configureCell() {
        configureContentView()
        configureProfileImage()
        configureLikeAndUpVoteButtons()
    }
    
    private func configureProfileImage() {
        profileImage.makeImageRound()
    }
    
    private func configureLikeAndUpVoteButtons() {
        likeAndUpVoteHStack.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.addArrangedSubview(likeAndUpVoteHStack)
    }
}
