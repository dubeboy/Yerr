//
//  StatusCell.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/11/21.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class StatusCell: UICollectionViewCell {
    
    private let videoPlayer: StatusVideoView = StatusVideoView()
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureVideoPlayer()
        configureImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        videoPlayer --> contentView
    }
    
    func showContent(content: MediaViewModel, statusText: String) {
        switch content.type {
            case .picture:
                videoPlayer.isHidden = true
                imageView.isHidden = false
                imageView.downloadImage(fromUrl: content.location)
            case .video:
                videoPlayer.setVideoPath(videoPath: content.location, status: statusText)
                videoPlayer.hideLabel()
                imageView.isHidden = true
                videoPlayer.isHidden = false
                videoPlayer.play()
            case .none:
                return
        }
      
    }
}

extension StatusCell {
    private func configureSelf() {
        
    }
    
    private func configureVideoPlayer() {
        videoPlayer.autoresizingOff()
        contentView.addSubview(videoPlayer)
        videoPlayer --> contentView
    }
    
    private func configureImageView() {
        imageView.autoresizingOff()
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView --> contentView
    
    }
}

