//
//  PostVideoStatusView.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/11/22.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit
import AVFoundation

class PostVideoStatusView: UIView {
    
//    https://iosexample.com/a-set-of-tools-written-in-swift-to-crop-and-trim-videos/
//    https://medium.com/@AppsBoulevard/tutorial-how-to-trim-videos-in-ios-with-abvideorangeslider-part-1-of-2-fe51893270ff
//    https://gist.github.com/acj/b8c5f8eafe0605a38692
//    https://github.com/AppsBoulevard/ABVideoRangeSlider
    
//    var videoPlayer: AVideo

    var videoPlayer = StatusVideoView()
    var sliderContainerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PostVideoStatusView {
    func configureSelf() {
        
    }
    
    func configureSliderContainerView() {
        sliderContainerView.autoresizingOff()
        addSubview(sliderContainerView)
        // TODO: add slider view here
        sliderContainerView.bottomAnchor --> bottomAnchor
        sliderContainerView.leadingAnchor --> leadingAnchor
        sliderContainerView.trailingAnchor --> trailingAnchor
    }
    
    func configureVideoView() {
        videoPlayer.autoresizingOff()
        addSubview(videoPlayer)
        videoPlayer --> self
    }
}
