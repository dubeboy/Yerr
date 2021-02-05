//
//  VideoView.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/11/16.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

protocol StatusVideoViewDelegate: class {
    func didFinishPlayingVideo()
    func didStartPlayingVideo()
    func currentlyPlaying(seconds: Double)
}

class StatusVideoView: UIView {
    
    private var statusLabel: UILabel = UILabel()
    
    private let avPlayer: AVPlayer = AVPlayer()
    let playerLayer: AVPlayerLayer // look into making inittilizing this async!!!
    private let effectsView = UIView()
    var endTIme: Float64 = 0
    var startTime: Float64 = .zero
    private var isPlaying: Bool = false
    
    private let playVideoButton = YerrButton()

    
    private var timeObserver: AnyObject!

    weak var delegate: StatusVideoViewDelegate? {
        didSet {
            if delegate == nil {
                NotificationCenter.default.removeObserver(self)
            } else {
                NotificationCenter.default.addObserver(self, selector: #selector(notifyPlayerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
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
        // get asset from url
        let item = AVPlayerItem(url: videoUrl)
        avPlayer.replaceCurrentItem(with: item) // TODO: listen to buffering here and show loading while buffering enable auto play back
        endTIme = videoDurationSeconds()
    }
    
    func setPHAsset(asset: PHAsset) {
        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .automatic
        options.progressHandler = { progress, _, _, _ in
            // The handler may originate on a background queue, so
            // re-dispatch to the main queue for UI work.
            DispatchQueue.main.sync {
                // self.progressView.progress = Float(progress)
            }
        }
        // Request an AVPlayerItem for the displayed PHAsset.
        // Then configure a layer for playing it.
        PHImageManager.default().requestPlayerItem(forVideo: asset, options: options, resultHandler: { playerItem, info in
            DispatchQueue.main.async {
                self.avPlayer.replaceCurrentItem(with: playerItem) // TODO: listen to buffering here and show loading while buffering enable auto play back
                self.endTIme = self.videoDurationSeconds()
            }
        })
    }
    
    func play(shouldNotify: Bool = true) {
        let timescale = self.avPlayer.currentItem?.asset.duration.timescale
        let myTime = CMTime(seconds: startTime, preferredTimescale: timescale ?? 60000)
        avPlayer.seek(to: myTime, toleranceBefore: .zero, toleranceAfter: .zero)
        avPlayer.play()
        if shouldNotify {
            notifyPlayerDidStartPlaying()
        }
    }
    
    func pause() {
        avPlayer.pause()
        notifyPlayerDidFinishPlaying()
    }
    
    init() {
        playerLayer = AVPlayerLayer(player: avPlayer)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        super.init(frame: .zero)
        configureSelf()
        configureEffectsView()
        configureAVPlayer()
        configurePlayVideoButton()
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pauseVideo))
        addGestureRecognizer(tapGesture)
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
    
    @objc private func notifyPlayerDidFinishPlaying() {
        isPlaying = false
        delegate?.didFinishPlayingVideo()
        DispatchQueue.main.async {
        UIView.animate(withDuration: 0.25) { [self] in
            
                playVideoButton.isHidden = false
            }
        }
    }
    
    private func notifyPlayerDidStartPlaying() {
        isPlaying = true
        delegate?.didStartPlayingVideo()
        DispatchQueue.main.async {
        UIView.animate(withDuration: 0.25) { [self] in
           
                playVideoButton.isHidden = true
            }
        }
        
    }
    
    @objc private func playVideo() {
        play()
    }
    
    @objc private func pauseVideo() {
        pause()
    }
    
    private func observeTime(elapsedTime: CMTime) {
        let elapsedTime = CMTimeGetSeconds(elapsedTime)
        delegate?.currentlyPlaying(seconds: elapsedTime)
        if avPlayer.currentTime().seconds > self.endTIme {
            avPlayer.pause()
            delegate?.didFinishPlayingVideo()
        }
    }
    
    private func configurePlayVideoButton() {
        playVideoButton.autoresizingOff()
        addSubview(playVideoButton)
        let image = Const.Assets.TrimVideo.playVideoIcon?.withRenderingMode(.alwaysTemplate)
        playVideoButton.setImage(fillBoundsWith: image)
        playVideoButton.tintColor = Const.Color.TrimVideo.playVideo
        playVideoButton.widthAnchor --> 80
        playVideoButton.heightAnchor --> 80
        playVideoButton.centerYAnchor --> centerYAnchor
        playVideoButton.centerXAnchor --> centerXAnchor
        playVideoButton.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
    }
}
