//
//  TrimVideoViewPresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/11/28.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

struct TrimVideoViewModel {
    var startTime: Float64
    var endTime: Float64
}

protocol TrimVideoViewPresenter {
    var videoURL: URL { get }
    var startTime: Float64 { get set}
    var endTime: Float64 { get set }
}

class TrimVideoViewPresenterImplementation {
    let videoURL: URL
    var viewModel = TrimVideoViewModel(startTime: 0, endTime: 0)

    init(videoURL: URL) {
        self.videoURL = videoURL
    }
}

extension TrimVideoViewPresenterImplementation: TrimVideoViewPresenter {
    var startTime: Float64 {
        get {
            viewModel.startTime
        }
        set {
            viewModel.startTime = newValue
        }
    }
    
    var endTime: Float64 {
        get {
            viewModel.endTime
        }
        set {
            viewModel.endTime = newValue
        }
    }
}
