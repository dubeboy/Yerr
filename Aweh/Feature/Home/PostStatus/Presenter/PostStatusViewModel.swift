//
//  PostStatusViewModel.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/09/29.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Photos

struct PostStatusViewModel {
    
    enum TextAlignment: Int {
        case left, right, center
    }
    
    enum TextWeight: Int {
        case bold, italic, normal
    }
    
    let placeHolderText: String = "Aweh!!! What's poppin'?"
    let numberOfAllowedChars = 240
    var locationState: LocationStateViewModel = .waiting
    var selectedImages: [String: PHAsset] = [:]
    let colors = Const.Color.PostStatus.textBackgroundColors
    let textColors = ["000000", "14213d", "fca311", "e5e5e5", "ffffff"]
    var selectedTextAlignment: TextAlignment = .center
    var textWeight: TextWeight = .normal
    
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
