//
//  EditVideoViewController.swift
//  Aweh
//
//  Created by Divine.Dube on 2021/01/05.
//  Copyright © 2021 com.github.aweh. All rights reserved.
//

import UIKit

class EditPhotoViewController: UIViewController {
    var presenter: EditPhotoPresenter!
    var coordinator: EditPhotoCoordinator!
    
    private let imageView: UIImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSelf()
        configureImageView()
        let image = UIImage(data: presenter.imageData[0])
        imageView.image = image
    }

    @objc func didTapAddText() {
        
    }
}

extension EditPhotoViewController {
    private func configureSelf() {
        
        addCloseButtonItem(toLeft: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Text", style: .plain, target: self, action: #selector(didTapAddText))
        
        imageView.autoresizingOff()
        view.addSubview(imageView)
        imageView --> view
    }
    private func configureImageView() {
        imageView.contentMode = .scaleAspectFit
    }
}
