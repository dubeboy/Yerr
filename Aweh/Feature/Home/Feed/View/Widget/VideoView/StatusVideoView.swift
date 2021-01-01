//
//  VideoView.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/11/16.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit
import AVFoundation

protocol StatusVideoViewDelegate: class {
    func didFinishPlayingVideo()
    func didStartPlayingVideo()
}

class StatusVideoView: UIView {
    
    private var statusLabel: UILabel = UILabel()
    
    private let avPlayer: AVPlayer = AVPlayer()
    let playerLayer: AVPlayerLayer
    let effectsView = UIView()
    weak var delegate: StatusVideoViewDelegate? {
        didSet {
            if delegate == nil {
                NotificationCenter.default.removeObserver(self)
            } else {
                NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
            }
        }
    }
        
    func play(videoPath: String, status: String = "") {
        statusLabel.text = status
        guard let videoUrl = URL(string: videoPath) else {
            Logger.log(AppStrings.Error.StatusVideoPlayer.invalidURL)
            return
        }
        // TODO: log when this fails to play video
        let item = AVPlayerItem(url: videoUrl)
        avPlayer.replaceCurrentItem(with: item)
        avPlayer.play()
        delegate?.didStartPlayingVideo()
    }
    
    init() {
        playerLayer = AVPlayerLayer(player: avPlayer)
        super.init(frame: .zero)
        configureSelf()
        configureEffectsView()
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

private extension StatusVideoView {
    private func configureSelf() {
        // effects we can use to blur the video player
        effectsView.autoresizingOff()
        addSubview(effectsView)
        effectsView --> self
        
        statusLabel.autoresizingOff()
        statusLabel.numberOfLines = 0
        statusLabel.lineBreakMode = .byWordWrapping
        statusLabel.textAlignment = .center
        effectsView.addSubview(statusLabel)
        
        statusLabel --> effectsView
        
        effectsView.layer.addSublayer(playerLayer)
        
    }
    
    private func configureEffectsView() {
        effectsView.backgroundColor = .green
    }
    
    @objc private func playerDidFinishPlaying() {
        delegate?.didFinishPlayingVideo()
    }
}
