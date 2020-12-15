//
//  TrimVideoViewPresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/11/28.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation


protocol TrimVideoViewPresenter {
    var videoURL: String { get }
    func getVideoURLAsUrlObject(success: Completion<URL>, failure: Completion<()>)
}

class TrimVideoViewPresenterImplementation {
    let videoURL: String
    
    
    
    init(videoURL: String) {
        self.videoURL = videoURL
    }
}

extension TrimVideoViewPresenterImplementation: TrimVideoViewPresenter {
    func getVideoURLAsUrlObject(success: (URL) -> Void, failure: (()) -> Void) {
        guard let url = URL(string: videoURL) else {
            Logger.log(AppStrings.Error.TrimVideo.cannotConvertStringURLToURLObject)
            failure(())
            return
        }
        success(url)
    }
}
