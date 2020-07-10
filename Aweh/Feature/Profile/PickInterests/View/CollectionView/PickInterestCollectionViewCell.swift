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
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        roundCorner()
    }
    
    func roundCorner() {
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = Const.view.radius
        containerView.backgroundColor = .systemGray5
    }
    @IBAction func didTapInterest(_ sender: Any) {
        action?()
    }
}
