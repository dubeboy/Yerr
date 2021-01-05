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
    
    private let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSelf()
        configureImageView()
        let image = UIImage(data: presenter.imageData[0])
        imageView.image = image
    }

    @objc func didTapAddText() {
        let overlayTextView = OverlayTextView(parent: imageView)
        overlayTextView.addToParent()
        overlayTextView.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.endEditing(true)
        listenToEvent(
            name: .keyboardWillShow,
            selector: #selector(keyboardWillAppear(notification:))
        )
        
        listenToEvent(
            name: .keyboardWillHide,
            selector: #selector(keyboardWillHide(notification:))
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        removeSelfFromNotificationObserver()
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        //        guard let frame = keyboardFrame(from: notification) else { return }
        //        videoTextEditorBottomAnchor.constant = -Const.View.m16
        // use this to change the center of the text and then reset it back
    }
    
    @objc func keyboardWillAppear(notification: NSNotification) {
        guard keyboardFrame(from: notification) != nil else { return }
        //        videoTextEditorBottomAnchor.constant = -frame.size.height - Const.View.m16
        // use this to change the center of the text and then reset it back
        
    }
    
    @objc func  didTapEndEditing() {
        view.endEditing(true)
    }
}

extension EditPhotoViewController {
    private func configureSelf() {
        
        addCloseButtonItem(toLeft: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Text", style: .plain, target: self, action: #selector(didTapAddText))
        
        imageView.autoresizingOff()
        view.addSubview(imageView)
        imageView --> view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapEndEditing))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
    }
    private func configureImageView() {
        imageView.contentMode = .scaleAspectFit
    }
}
