//
//  CaptureStatusPresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2021/01/05.
//  Copyright © 2021 com.github.aweh. All rights reserved.
//

import Foundation
import Photos

struct CaptureStatusPresenterViewModel {
    var isClosed: Bool = false
}

protocol CaptureStatusPresenter {
    func getImages(avAssets: [String: PHAsset], completion: @escaping (Bool, [Data]) -> Void)
    var photosCollectionViewPresenter: PhotosCollectionViewPresenter { get }
    var isImageDrawerClosed: Bool { get set }
}

class CaptureStatusPresenterImplementation {
    private var viewModel = CaptureStatusPresenterViewModel()
    
    let photosCollectionViewPresenter: PhotosCollectionViewPresenter = PhotosCollectionViewPresenterImplemantation()
    private let manager = PHImageManager.default()
}

extension CaptureStatusPresenterImplementation: CaptureStatusPresenter {
    var isImageDrawerClosed: Bool {
        get {
            viewModel.isClosed
        }
        set {
            viewModel.isClosed = newValue
        }
    }
    
    
    func getImages(avAssets: [String: PHAsset], completion: @escaping (Bool, [Data]) -> Void) {
        let group = DispatchGroup()
        var images = [Data]()
        var didFailOnce = false
        
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .opportunistic // should look into this please
        options.progressHandler = { progress, _, _, _ in
            // The handler may originate on a background queue, so
            // re-dispatch to the main queue for UI work.
            DispatchQueue.main.sync {
                // self.progressView.progress = Float(progress)
            }
        }
        
        for (_, value) in avAssets {
            group.enter()
            manager.requestImageData(for: value, options: options) { imageData,_,_,_ in
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

