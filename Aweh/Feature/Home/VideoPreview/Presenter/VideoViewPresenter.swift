//
//  VideoViewPresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/12/12.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

protocol VideoViewPresenter {
    var videoURL: String { get }
}

class VideoViewPresenterImplementation: VideoViewPresenter {
    var videoURL: String
    
    init(videoURL: String) {
        self.videoURL = videoURL
    }
}
