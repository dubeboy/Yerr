//
//  UIImageView+Elements.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/07/19.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

extension UIImageView {
    
    static var service: SingletonServiceInstance {
        SingletonServiceInstance()
    }
    
    func downloadImage(fromUrl: String?) {
        backgroundColor = Const.Color.lightGray
        // cache images here
        Self.service.projectedValue.$getAsset(["id": fromUrl ?? ""]) { response in
            switch response {
                case .success(let response):
                    // show loading indcator here
                    let image = UIImage(data: response.body)
                    self.image = image
                case .failure(let error):
                    Logger.log(error)
            }
        }
    }
}
