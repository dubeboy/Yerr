//
//  VideoView.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/11/16.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit
import AVFoundation

class StatusVideoView: UIView {
    
    private var statusLabel: UILabel = UILabel()
    
    private let avPlayer: AVPlayer = AVPlayer()
    private let playerLayer: AVPlayerLayer
        
    func play(videoPath: String, status: String) {
        statusLabel.text = status
        guard let videoUrl = URL(string: videoPath) else {
            Logger.log(AppStrings.Error.StatusVideoPlayer.invalidURL)
            return
        }
        // TODO: log when this fails to play video
        let item = AVPlayerItem(url: videoUrl)
        avPlayer.replaceCurrentItem(with: item)
        avPlayer.play()
    }
    
    init() {
        playerLayer = AVPlayerLayer(player: avPlayer)
        super.init(frame: .zero)
        self.layer.addSublayer(playerLayer)
        configureSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = self.bounds
    }
    
    func hideLabel() {
        statusLabel.isHidden = true
    }
    
    func showLabel() {
        statusLabel.isHidden = false
    }
}

extension StatusVideoView {
    private func configureSelf() {
        let effectsView = UIView() // effects we can use to blur the video player
        effectsView.autoresizingOff()
        effectsView.bottomAnchor --> bottomAnchor + Const.View.m16
        effectsView.leadingAnchor --> leadingAnchor + Const.View.m16 * 2
        effectsView.trailingAnchor --> trailingAnchor + Const.View.m16 * -2
        
        statusLabel.autoresizingOff()
        statusLabel.numberOfLines = 0
        statusLabel.lineBreakMode = .byWordWrapping
        statusLabel.textAlignment = .center
        effectsView.addSubview(statusLabel)
        
        statusLabel --> effectsView
    }
}
