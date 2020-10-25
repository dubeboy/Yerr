//
//  InfoInput.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/10/24.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class InfoInput: UIViewController {
    var userProfileImageView: UIImageView = UIImageView()
    var nameTextField = UITextField()
    var handleField = UITextField()
    var nameHandleStackView = UIStackView()
    var editButton = YerrButton(frame: .zero)
    
    var presenter: InfoInputPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = presenter.title
        configureSelf()
        configurenameHandleStackView()
    }
}

extension InfoInput {
    private func configureSelf() {
        userProfileImageView.autoresizingOff()
        view.addSubview(userProfileImageView)
        userProfileImageView.leadingAnchor --> view.leadingAnchor
        userProfileImageView.widthAnchor --> 150
        userProfileImageView.heightAnchor --> 150
        userProfileImageView.topAnchor --> view.topAnchor + Const.View.m16
        editButton.autoresizingOff()
        userProfileImageView.addSubview(editButton)
        editButton --> userProfileImageView
        editButton.setImage(Const.Assets.InitInfoInput.editButton, for: .normal)
        editButton.backgroundColor = Const.Color.lightGray
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
