//
//  TrimVideoViewPresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/11/28.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation
import Merchant
import AVFoundation

struct TrimVideoViewModel {
    var startTime: Float64
    var endTime: Float64
    var textBeingEdited: [String]
    var locationState: LocationStateViewModel = .waiting
    var colors: [String] = Const.Color.TrimVideo.textBackgroundColors
    
    var currentLocation: Location? = nil {
        didSet {
            if currentLocation != nil {
                locationState = .success
            } else {
                locationState = .error
            }
        }
    }
}

protocol TrimVideoViewPresenter {
    var videoURL: URL { get }
    var startTime: Float64 { get set }
    var endTime: Float64 { get set }
    var colors: [String] { get }
   
    func appendEditableTextAndGetTag(text: String) -> Int
    func postVideo(videoURL: URL, completion: @escaping Completion<()>, failure: @escaping Completion<String>)
}

class TrimVideoViewPresenterImplementation {
    let videoURL: URL
    var viewModel = TrimVideoViewModel(startTime: 0, endTime: 0, textBeingEdited: [])
    let postStatusInteractor: StatusesUseCase = FeedInteractor()
    
    init(videoURL: URL) {
        self.videoURL = videoURL
    }
}

extension TrimVideoViewPresenterImplementation: TrimVideoViewPresenter {
    var colors: [String] {
        viewModel.colors
    }
    
    func postVideo(videoURL: URL, completion: @escaping Completion<()>, failure: @escaping Completion<String>) {
        
        let location = viewModel.currentLocation == nil ? {
            Logger.wtf("current location does not exist this is wrong!!!, should not happen ")
            return Location.dummyLocation
        }() :  viewModel.currentLocation!
        
        
        do {
            let data = try Data(contentsOf: videoURL)
            let multipartBody = MultipartBody(name: "files", body: data, filename: videoURL.lastPathComponent, mime: "video/quicktime")
            let statusEntity = Status(id: nil, // add default value to make this shorter please!!!
                                      body: "Empty for now",
                                      user: .dummyUser,
                                      comments: [],
                                      location: location,
                                      media: [],
                                      likes: 0,
                                      votes: 0,
                                      createdAt: Date(),
                                      circleName: "Food")
            postStatusInteractor.postStatuses(status: statusEntity, statusMultipart: [multipartBody]) { result in
                switch result {
                    case .success( _):
                        completion(())
                    case .failure(let error):
                        failure(error.localizedDescription)
                }
            }
        } catch {
            Logger.log("okay failed to convert url to data object \(error)")
            failure(AppStrings.Error.genericError)
        }
    }
    
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
