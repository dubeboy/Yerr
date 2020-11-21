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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureVideoPlayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        videoPlayer --> contentView
    }
    
    func playContent(videoPath: String, statusText: String) {
        videoPlayer.play(videoPath: videoPath, status: statusText)
    }
}

extension StatusCell {
    private func configureSelf() {
        
    }
    
    private func configureVideoPlayer() {
        videoPlayer.autoresizingOff()
        contentView.addSubview(videoPlayer)
    }
}

