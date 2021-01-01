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
    var textBeingEdited: [String]
}

protocol TrimVideoViewPresenter {
    var videoURL: URL { get }
    var startTime: Float64 { get set}
    var endTime: Float64 { get set }
   
    func appendEditableTextAndGetTag(text: String) -> Int
}

class TrimVideoViewPresenterImplementation {
    let videoURL: URL
    var viewModel = TrimVideoViewModel(startTime: 0, endTime: 0, textBeingEdited: [])

    init(videoURL: URL) {
        self.videoURL = videoURL
    }
}

extension TrimVideoViewPresenterImplementation: TrimVideoViewPresenter {
    func appendEditableTextAndGetTag(text: String) -> Int {
        viewModel.textBeingEdited.append(text)
        return viewModel.textBeingEdited.endIndex
    }

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
