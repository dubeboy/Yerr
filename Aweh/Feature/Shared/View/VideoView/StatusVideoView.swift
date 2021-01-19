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
    func currentlyPlaying(seconds: Double)
}

class StatusVideoView: UIView {
    
    private var statusLabel: UILabel = UILabel()
    
    private let avPlayer: AVPlayer = AVPlayer()
    let playerLayer: AVPlayerLayer
    private let effectsView = UIView()
    var endTIme: Float64 = 0
    var startTime: Float64 = .zero
    
    private var timeObserver: AnyObject!

    weak var delegate: StatusVideoViewDelegate? {
        didSet {
            if delegate == nil {
                NotificationCenter.default.removeObserver(self)
            } else {
                NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
            }
        }
    }
        
    func setVideoPath(videoPath: String, status: String = "") {
        statusLabel.text = status
        guard let videoUrl = URL(string: videoPath) else {
            Logger.log(AppStrings.Error.StatusVideoPlayer.invalidURL)
            return
        }
        // TODO: log when this fails to play video
        let item = AVPlayerItem(url: videoUrl)
        avPlayer.replaceCurrentItem(with: item)
        endTIme = videoDurationSeconds()
    }
    
    func play(shouldNotify: Bool = true) {
        let timescale = self.avPlayer.currentItem?.asset.duration.timescale
        let myTime = CMTime(seconds: startTime, preferredTimescale: timescale ?? 60000)
        avPlayer.seek(to: myTime, toleranceBefore: .zero, toleranceAfter: .zero)
        avPlayer.play()
        if shouldNotify {
            delegate?.didStartPlayingVideo()
        }
    }
    
    func pause() {
        avPlayer.pause()
        delegate?.didFinishPlayingVideo()
    }
    
    init() {
        playerLayer = AVPlayerLayer(player: avPlayer)
        super.init(frame: .zero)
        configureSelf()
        configureEffectsView()
        configureAVPlayer()
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
    
    func videoDurationSeconds() -> Float64 {
        CMTimeGetSeconds(avPlayer.currentItem!.duration)
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
    
    private func configureAVPlayer() {
        let timeInterval: CMTime = CMTimeMakeWithSeconds(0.01, preferredTimescale: 100)
        timeObserver = avPlayer.addPeriodicTimeObserver(forInterval: timeInterval, queue: .main, using: { [weak self] elapsedTime in
            self?.observeTime(elapsedTime: elapsedTime)
        }) as AnyObject
    }
    
    private func configureEffectsView() {
        effectsView.backgroundColor = .clear
    }
    
    @objc private func playerDidFinishPlaying() {
        delegate?.didFinishPlayingVideo()
    }
    
    private func observeTime(elapsedTime: CMTime) {
        let elapsedTime = CMTimeGetSeconds(elapsedTime)
        delegate?.currentlyPlaying(seconds: elapsedTime)
        if avPlayer.currentTime().seconds > self.endTIme {
            avPlayer.pause()
            delegate?.didFinishPlayingVideo()
        }
    }
    
  
}
