//
//  AssetDetailPresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/14.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation
import Photos

protocol AssetDetailPresenter {
    var asset: PHAsset { get set }
    func getAsset()
}

class AssetDetailPresenterImplementation: AssetDetailPresenter  {
    var asset: PHAsset
    
    init(asset: PHAsset) {
        self.asset = asset
    }
    
    func getAsset() {
        
    }
}

