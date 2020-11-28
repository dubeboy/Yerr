//
//  PostStatusPreview.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/11/23.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class PostStatusVideoPreview: UIView {
    private var rangeSliderView: TimePostVideoRangeSlider = TimePostVideoRangeSlider()
    private var videoView: StatusVideoView = StatusVideoView()
    
    init() {
        super.init(frame: .zero)
        configureSelf()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rangeSliderDelegate(delegate: TimePostVideoRangeSliderDelegate) {
        rangeSliderView.delegate = delegate
    }
    
    func play(videoPath: String, status: String) {
        videoView.play(videoPath: videoPath, status: status)
    }
}

//MARK: private functions

private extension PostStatusVideoPreview {
    func configureSelf() {
        rangeSliderView.autoresizingOff()
        videoView.autoresizingOff()
        
        videoView.hideLabel()
        
        addSubview(videoView)
        videoView --> self
        addSubview(rangeSliderView)
        
        rangeSliderView.leadingAnchor --> self.leadingAnchor + Const.View.m16
        rangeSliderView.trailingAnchor --> self.trailingAnchor + -Const.View.m16
        rangeSliderView.bottomAnchor --> self.bottomAnchor + -Const.View.m16 * 2
    }
}

