//
//  GaugeView.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/07/07.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

@IBDesignable
class GaugeView: UIView {
    var view: UIView!
    var darkBorderLayer: BorderLayer!
    var progressBorderLayer: BorderLayer!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBInspectable
    var image: UIImage? = nil {
        didSet {
            userImage.image = image
        }
    }
    
    @IBInspectable
    var progress: CGFloat = 0.0 {
        didSet {
            progressBorderLayer.endAngle = BorderLayer.radianForValue(progress)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNib()
        commonInit()
    }
    
    
    private func loadFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [
            .flexibleWidth,
            .flexibleHeight
        ]
        addSubview(view)
        self.view = view
    }
    
    private func commonInit() {
        darkBorderLayer = BorderLayer()
        darkBorderLayer.lineColor = UIColor.yellow.cgColor
        darkBorderLayer.startAngle = BorderLayer.startAngle
        darkBorderLayer.endAngle = BorderLayer.endAngle
        self.layer.addSublayer(darkBorderLayer)
        
        progressBorderLayer = BorderLayer()
        progressBorderLayer.lineColor = UIColor.purple.cgColor
        progressBorderLayer.startAngle =  BorderLayer.startAngle
        progressBorderLayer.endAngle = BorderLayer.endAngle
        self.layer.addSublayer(progressBorderLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        darkBorderLayer.frame = self.bounds
        progressBorderLayer.frame = self.bounds
        darkBorderLayer.setNeedsDisplay()
        progressBorderLayer.setNeedsDisplay()
    }
    
}
