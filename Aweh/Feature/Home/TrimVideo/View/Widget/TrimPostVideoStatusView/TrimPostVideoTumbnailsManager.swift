//
//  TrimPostVideoTumbnailsManager.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/11/23.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit
import AVFoundation

class TrimPostVideoTumbnailsManager: NSObject {
    
    var thumbnailViews = [UIImageView]()
    
    func updateThumbnails(view: UIView, videoURL: URL, duration: Float64) -> [UIImageView] {
        var thumbnails = [UIImage]()
        var offset: Float64 = 0
        
        for view in self.thumbnailViews {
            DispatchQueue.main.sync {
                view.removeFromSuperview()
            }
        }
        
        let imagesCount = self.thumbnailCount(inView: view)
        
        for i in 0..<imagesCount {
            let thumbnail = thumbnailFromVideo(videoURL: videoURL, time: CMTime(value: Int64(offset), timescale: 1))
            offset = Float64(i) * (duration / Float64(imagesCount))
            thumbnails.append(thumbnail)
        }
        
        self.addImagesToView(images: thumbnails, view: view)
        return self.thumbnailViews
    }
    

    static func videoDuration(videoURL: URL) -> Float64 {
        let source = AVURLAsset(url: videoURL)
        let timeInSeconds = CMTimeGetSeconds(source.duration)
        return timeInSeconds
    }
}

extension TrimPostVideoTumbnailsManager {
    private func thumbnailFromVideo(videoURL: URL, time: CMTime) -> UIImage {
        let asset: AVAsset = AVAsset(url: videoURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        do {
            
            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            let uiImage = UIImage(cgImage: cgImage)
            return uiImage
        } catch {
           // TODO: catch this error and send to analytics
        }
        
        return UIImage()
    }
    
    private func addImagesToView(images: [UIImage], view: UIView) {
        self.thumbnailViews.removeAll()
        var xPos: CGFloat = 0.0
        var width: CGFloat = 0.0
        
        for image in images {
            DispatchQueue.main.async {
                if xPos + view.frame.size.height < view.frame.width {
                    width = view.frame.size.height
                } else {
                    width = view.frame.size.width - xPos
                }
                
                let imageView = UIImageView(image: image)
                imageView.alpha = 0
                imageView.contentMode = .scaleToFill
                imageView.clipsToBounds = true
                imageView.frame = CGRect(x: xPos,
                                         y: 0.0,
                                         width: width,
                                         height: view.frame.size.height)
                
                self.thumbnailViews.append(imageView)
                
                view.addSubview(imageView)
                UIView.animate(withDuration: 0.2) {
                    imageView.alpha = 1.0
                }
                
                view.sendSubviewToBack(imageView)
                xPos = xPos + view.frame.size.height
            }
        }
    }
    
    private func thumbnailCount(inView: UIView) -> Int {
        var num: Double = 0
        DispatchQueue.main.sync {
            num = Double(inView.frame.size.width) / Double(inView.frame.size.height)
        }
        return Int(ceil(num)) // TODO: crashed some times
    }
    
}
