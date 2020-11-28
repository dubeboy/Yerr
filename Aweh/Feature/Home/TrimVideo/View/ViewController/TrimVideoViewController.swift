//
//  TrimVideoViewController.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/11/28.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class TrimVideoViewController: UIViewController {
    
    var presenter: TrimVideoViewPresenter!
    var coordinator: HomeCoordinator!
    
    let videoView = PostStatusVideoPreview()
//    let progressIndicator // for when the asset need to be downloaded

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSelf()
        
        videoView.play(videoPath: presenter.videoURL)
        
    }
}

// MARK: private functions

private extension TrimVideoViewController {
    private func configureSelf() {
        videoView.autoresizingOff()
        view.addSubview(videoView)
        videoView --> view
        videoView.rangeSliderDelegate(delegate: self)
        addCloseButtonItem()
    }
}

extension TrimVideoViewController: TimePostVideoRangeSliderDelegate {
    func didChangeValue(videoRangeSlider: TimePostVideoRangeSliderView, startTime: Float64, endTime: Float64) {
        
    }
    
    func indicatorDidChangePosition(videoRangeSlider: TimePostVideoRangeSliderView, position: Float64) {
        
    }
    
    func sliderGestureBegan() {
        
    }
    
    func sliderGestureEnded() {
        
    }
}
