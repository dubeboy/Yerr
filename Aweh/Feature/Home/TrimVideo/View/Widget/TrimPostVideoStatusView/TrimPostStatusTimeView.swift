//
//  TimePostStatusTimeView.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/11/23.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class TrimPostStatusTimeView: UIView {
    let space: CGFloat = 8.0
    
    public var timeLabel = UILabel()
    public var backgroundView = UIView() {
        willSet {
            self.backgroundView.removeFromSuperview()
        }
        didSet {
            self.frame = CGRect(x: 0,
                                y: -backgroundView.frame.height - space,
                                width: backgroundView.frame.width,
                                height: backgroundView.frame.height)
            
            self.addSubview(backgroundView)
            self.sendSubviewToBack(backgroundView)
        }
    }
    
    public var marginTop: CGFloat = 5.0
    public var marginBottom: CGFloat = 5.0
    public var marginLeft: CGFloat = 5.0
    public var marginRight: CGFloat = 5.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(size: CGSize) {
        let frame = CGRect(x: 0,
                           y: -size.height,
                           width: size.width,
                           height: size.height)
        super.init(frame: frame)
        
        // add background view
        self.backgroundView.frame = self.bounds
        self.backgroundView.backgroundColor = UIColor.yellow
        self.addSubview(self.backgroundView)
        
        // add time label
        timeLabel.frame = self.bounds
        timeLabel.backgroundColor = UIColor.yellow
        timeLabel.textColor = UIColor.lightGray
        addSubview(timeLabel)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.frame = self.bounds
        let timeLabelFrameWidth = self.frame.width - (marginRight + marginLeft)
        let timeLabelFrameHeight = self.frame.height - (marginBottom + marginTop)
        
        self.timeLabel.frame = CGRect(x: marginLeft,
                                      y: marginTop - self.timeLabel.bounds.height / 2,
                                      width: timeLabelFrameWidth,
                                      height: timeLabelFrameHeight)
    }
}
