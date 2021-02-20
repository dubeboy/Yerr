//
// Created by Divine.Dube on 2020/08/28.
// Copyright (c) 2020 com.github.aweh. All rights reserved.
//

import Foundation

enum MediaTypeViewModel: Int {
    case video, picture, none = -1
}

struct MediaViewModel: Hashable {
    let name: String
    let type: MediaTypeViewModel
    let location: String
    let createAt: Date
    
    var path: String {
        switch type {
            case .video:
                let url =  AwehService.assetsBaseURL + location + ".mp4"
                Logger.i("Genarated Video URL \(url)")
                return url
            case .picture:
                return location
            case .none:
                Logger.log("Location for asset has no type. Location: \(location)")
                return ""
        }
    }
}

extension MediaViewModel {
    static func transform(media: Media) -> MediaViewModel {
        return MediaViewModel(name: media.name, type:
                                MediaTypeViewModel(rawValue: media.type.rawValue) ?? .none,
                                                   location: media.location,
                                                   createAt: media.createAt)
    }
}
