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
    private var layers: [BorderLayer] = []
    private var tracks: [BorderLayer] = []
        
    @IBOutlet weak var userImage: UIImageView!
    
    static let startAngle = -(1/2) * CGFloat.pi
    static let endAngle = (7/2) * CGFloat.pi
    
    init(values: GuageViewViewModel) {
        super.init(frame: .zero)
        commonInit(values: values)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNib()
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
    
    private func commonInit(values: GuageViewViewModel) {
        values.values.enumerated().forEach { [self] index, value in
            let darkBorderLayer = BorderLayer()
            let track = BorderLayer()
            track.lineColor = UIColor.systemGray6.cgColor
            track.startAngle = Self.startAngle
            track.endAngle = Self.endAngle
            
            darkBorderLayer.lineColor = getColorWith(at: index)
            darkBorderLayer.startAngle = Self.startAngle
            darkBorderLayer.endAngle = Self.radianForValue(CGFloat(value))
            
            layer.addSublayer(track)
            layer.addSublayer(darkBorderLayer)
            tracks.append(track)
            layers.append(darkBorderLayer)
        }
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        precondition(tracks.count == layers.count, "There should be same amount of tracks and layers")
        layers.enumerated().forEach { index, layer in
            let insetAtIndex = calculateInset(index)
            let frameAtIndex = self.bounds.insetBy(dx: insetAtIndex, dy: insetAtIndex)
            let track = tracks[index]
            layer.frame = frameAtIndex
            track.frame = frameAtIndex
            
            track.setNeedsDisplay()
            layer.setNeedsDisplay()
        }
       
    }
    
    func set(values: GuageViewViewModel) {
        commonInit(values: values)
        setNeedsLayout()
    }
    
    private func calculateInset(_ index: Int) -> CGFloat {
        CGFloat(index * 11)
    }
    
    private func getColorWith(at index: Int) -> CGColor {
        switch index {
            case 0:
                return UIColor.systemRed.cgColor
            default:
                return UIColor.systemGray.cgColor
        }
    }
    
    
    static func radianForValue(_ value: CGFloat) -> CGFloat {
        let realValue = Self.sanitizeValue(value: value)
        return (realValue * 4/2 * CGFloat.pi/100) + Self.startAngle
    }
    
    static func sanitizeValue(value: CGFloat) -> CGFloat {
        var realValue = value
        if value < 0 {
            realValue = 0
        } else if value > 100 {
            realValue = 100
        }
        return realValue
    }
    
}