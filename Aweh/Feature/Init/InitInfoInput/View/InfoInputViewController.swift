//
//  InfoInput.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/10/24.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class InfoInputViewController: UIViewController {
    private var userProfileImageView: UIImageView = UIImageView()
    private var nameTextField = UITextField()
    private var handleField = UITextField()
    private var nameHandleStackView = UIStackView()
    private var editProfileImageButton = YerrButton(frame: .zero)
    
    var coordinator: InitScreensCoordinator!
    
    var presenter: InfoInputPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = presenter.title
        configureSelf()
        configurenameHandleStackView()
        
        // add a close UIBarItem here
    }
}

extension InfoInputViewController {
    private func configureSelf() {
        userProfileImageView.autoresizingOff()
        view.addSubview(userProfileImageView)
        userProfileImageView.leadingAnchor --> view.leadingAnchor
        userProfileImageView.widthAnchor --> 150
        userProfileImageView.heightAnchor --> 150
        userProfileImageView.topAnchor --> view.topAnchor + Const.View.m16
        editProfileImageButton.autoresizingOff()
        userProfileImageView.addSubview(editProfileImageButton)
        editProfileImageButton --> userProfileImageView
        editProfileImageButton.setImage(Const.Assets.InitInfoInput.editButton, for: .normal)
        editProfileImageButton.backgroundColor = Const.Color.lightGray
    }
    
    private func configurenameHandleStackView() {
        nameHandleStackView.autoresizingOff()
        nameHandleStackView.axis = .vertical
        nameHandleStackView.alignment = .leading
        nameHandleStackView.distribution = .fillEqually
        nameHandleStackView.spacing = Const.View.m8
        view.addSubview(nameHandleStackView)
        nameHandleStackView.topAnchor --> userProfileImageView.topAnchor
        nameHandleStackView.leadingAnchor --> userProfileImageView.trailingAnchor
        nameHandleStackView.trailingAnchor --> view.trailingAnchor + Const.View.m16
        
        nameTextField.autoresizingOff()
        nameTextField.autoresizingOff()
        nameHandleStackView.addArrangedSubview(nameTextField)
        nameTextField.placeholder = presenter.namePlaceHolder
        nameHandleStackView.addArrangedSubview(handleField)
        handleField.placeholder = presenter.handleFieldPlaceHolder
        
    }
}
