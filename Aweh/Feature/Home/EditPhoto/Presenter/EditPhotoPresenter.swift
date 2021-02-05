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
import UIKit

protocol EditPhotoPresenter {
    var photosCollectionPresenter: PhotosCollectionViewPresenter { get }
    var imageData: Data? { get }
    var phAssets: [PHAsset]? { get }
    func postEditedImages(status: String, images: [Data], completion: @escaping (()) -> Void, failure: @escaping (String) -> Void)
    func getPHAsset(asset: PHAsset,
                    targetSize: CGSize,
                    progressHandler: @escaping Completion<Float>,
                    completion:  @escaping Completion<UIImage?>)
}

class EditPhotoPresenterImplementation {
    
    let imageData: Data?
    let phAssets: [PHAsset]?
    let postStatusInteractor: StatusesUseCase = FeedInteractor()
    var photosCollectionPresenter: PhotosCollectionViewPresenter = PhotosCollectionViewPresenterImplemantation()
    
    init(imageData: Data) {
        self.imageData = imageData
        self.phAssets = nil
    }
    
    init(phAssets: [PHAsset]) {
        self.imageData = nil
        self.phAssets = phAssets
    }
}

extension EditPhotoPresenterImplementation: EditPhotoPresenter {
    func getPHAsset(asset: PHAsset,
                    targetSize: CGSize,
                    progressHandler: @escaping Completion<Float>,
                    completion:  @escaping Completion<UIImage?>) {
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.progressHandler = { progress, _, _, _ in
            DispatchQueue.main.sync {
                progressHandler(Float(progress))
            }
        }
        
        
        PHImageManager.default().requestImage(for: asset,
                                              targetSize: targetSize,
                                              contentMode: .aspectFill,
                                              options: options) { (image, _) in
            completion(image)
        }
    }
    
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
