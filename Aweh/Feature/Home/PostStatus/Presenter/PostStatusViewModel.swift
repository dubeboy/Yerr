//
//  PostStatusViewModel.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/09/29.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Photos

struct PostStatusViewModel {
    
    let placeHolderText: String = "Aweh!!! What's poppin'?"
    let numberOfAllowedChars = 240
    var locationState: LocationStateViewModel = .waiting
    var selectedImages: [String: PHAsset] = [:]
    
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
