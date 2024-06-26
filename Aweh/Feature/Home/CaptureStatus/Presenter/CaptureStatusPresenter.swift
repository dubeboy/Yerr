//
//  CaptureStatusPresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2021/01/05.
//  Copyright © 2021 com.github.aweh. All rights reserved.
//

import Foundation
import Photos

protocol CaptureStatusPresenter {
    func getImages(avAssets: [String: PHAsset], completion: @escaping (Bool, [Data]) -> Void)
    var photosCollectionViewPresenter: PhotosCollectionViewPresenter { get }
}

class CaptureStatusPresenterImplementation {
    let photosCollectionViewPresenter: PhotosCollectionViewPresenter = PhotosCollectionViewPresenterImplemantation()
    private let manager = PHImageManager.default()
}

extension CaptureStatusPresenterImplementation: CaptureStatusPresenter {
    func getImages(avAssets: [String: PHAsset], completion: @escaping (Bool, [Data]) -> Void) {
        let group = DispatchGroup()
        var images = [Data]()
        var didFailOnce = false
        for (_, value) in avAssets {
            group.enter()
            manager.requestImageData(for: value, options: nil) { imageData,_,_,_ in
                guard let imageData = imageData else {
                    didFailOnce = true
                    Logger.log("Got back a null image this should never happen!!!")
                    group.leave()
                    return
                }
                images.append(imageData)
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(didFailOnce, images)
        }
    }
}

