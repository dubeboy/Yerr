//
//  UIImage+Elements.swift
//  Aweh
//
//  Created by Divine.Dube on 2021/01/30.
//  Copyright © 2021 com.github.aweh. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    var avarageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x,
                                    y: inputImage.extent.origin.y,
                                    z: inputImage.extent.size.width,
                                    w: inputImage.extent.size.height)
        
        guard let filter = CIFilter(name: "CIAreaAvarage", parameters: [kCIInputExtentKey: extentVector, kCIInputImageKey: inputImage]) else { return nil }
        guard let outputImage = filter.outputImage else {  return nil  }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull as Any])
        context.render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(origin: .zero, size: CGSize(width: 1, height: 1)),
                       format: .RGBA8, colorSpace: nil)
        
        return UIColor(red: CGFloat(bitmap[0]) / 255, green:  CGFloat(bitmap[1]) / 255, blue:  CGFloat(bitmap[2]) / 255, alpha:  CGFloat(bitmap[3]) / 255)
    }
}
