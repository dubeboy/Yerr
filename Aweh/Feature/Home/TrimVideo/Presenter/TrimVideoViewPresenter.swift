//
//  TrimVideoViewPresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/11/28.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation


protocol TrimVideoViewPresenter {
    var videoURL: URL { get }
}

class TrimVideoViewPresenterImplementation {
    let videoURL: URL

    init(videoURL: URL) {
        self.videoURL = videoURL
    }
}

extension TrimVideoViewPresenterImplementation: TrimVideoViewPresenter {
   
}
