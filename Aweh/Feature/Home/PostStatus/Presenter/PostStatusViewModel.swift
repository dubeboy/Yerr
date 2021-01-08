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
    let colors = ["264653", "2A9D8F", "e9c46a", "f4a261", "e76f51"]
    let textColors = ["000000", "14213d", "fca311", "e5e5e5", "ffffff"]
    
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
