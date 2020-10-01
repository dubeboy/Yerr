//
//  AssetsHorizontalListView.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/13.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit
import Photos

/// Fetchs the images and displayes them
class AssetsHorizontalListView: UIScrollView {
   let stackView: UIStackView = UIStackView()
    private var imageHeight: CGFloat = 80
 
   init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        stackView.spacing = 8
        addSubview(stackView)
        stackView --> self
        self.heightAnchor --> imageHeight
        stackView.heightAnchor --> imageHeight
        
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }
    
    func addImages(assets: [String: PHAsset]) {
        fetchImages(from: assets)
    }
//    https://developer.apple.com/documentation/uikit/uiimage/1624115-jpegdata
    private func fetchImages(from assets: [String: PHAsset] ) {
        let rect = CGRect(x: 0, y: 0, width: imageHeight, height: imageHeight)
        let imageManager = PHImageManager.default()
        for (_, asset) in assets {
            let imageView = UIImageView(frame: rect)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.heightAnchor --> imageHeight
            stackView.addArrangedSubview(imageView)
            // TODO: show some for of loading indicator here bro 
            imageManager.requestImage(
                for: asset,
                targetSize: rect.size,
                contentMode: .aspectFill,
                options: nil // TODO: Check available option to optimse
            ) { image, _ in
                imageView.image = image
            }
        }
    }
}
