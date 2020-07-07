//
//  PickInterestCollectionViewCell.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/07/05.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class PickInterestCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var addToInterest: UIButton!
    @IBOutlet weak var interestName: UILabel!
    
    var action: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        roundCorner()
    }
    
    func roundCorner() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = Const.view.radius
        contentView.backgroundColor = .systemBackground
    }
    @IBAction func didTapInterest(_ sender: Any) {
        action?()
    }
}
