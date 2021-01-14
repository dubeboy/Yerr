//
//  EditVideoPresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2021/01/05.
//  Copyright © 2021 com.github.aweh. All rights reserved.
//

import Foundation
import Photos
import Merchant

protocol EditPhotoPresenter {
    var imageData: [Data] { get }
    func postEditedImages(status: String, images: [Data], completion: @escaping (()) -> Void, failure: @escaping (String) -> Void)
}

class EditPhotoPresenterImplementation {
    
    let imageData: [Data]
    let postStatusInteractor: StatusesUseCase = FeedInteractor()
    
    init(imageData: [Data]) {
        self.imageData = imageData
    }
}

extension EditPhotoPresenterImplementation: EditPhotoPresenter {
    func postEditedImages(status: String, images: [Data], completion: @escaping (()) -> Void, failure: @escaping (String) -> Void) {
        let location = Location.dummyLocation
        
        let multipartBody = images.map { data in
            MultipartBody(name: "files", body: data, filename: "\(UUID().uuidString).png", mime: "image/png")
        }
        
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
        postStatusInteractor.postStatuses(status: statusEntity, statusMultipart: multipartBody) { result in
            switch result {
                case .success(let status):
                    completion(())
                case .failure(let error):
                    failure(error.localizedDescription)
            }
        }

    }
}
