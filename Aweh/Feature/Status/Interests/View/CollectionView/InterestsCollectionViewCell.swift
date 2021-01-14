//
//  InterestsCollectionViewCell.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/24.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class InterestsCollectionViewCell: UICollectionViewCell {

    // TODO: create three layers of this and add then on top of each other
    let interestsContainerView: InterestsContainerView
    
    override init(frame: CGRect) {
        interestsContainerView = InterestsContainerView(frame: frame)
        super.init(frame: frame)
        interestsContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(interestsContainerView)
        interestsContainerView --> self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Hide layers
    }
}
