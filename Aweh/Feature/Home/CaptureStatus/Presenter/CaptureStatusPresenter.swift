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
}

